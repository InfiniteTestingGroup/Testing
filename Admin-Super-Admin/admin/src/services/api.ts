import axios from 'axios';
import { AD_MOBILE_BACKEND_URL, ADMIN_BACKEND_URL } from '../config/constants';

// ── Admin Spring Boot Backend ─────────────────────────────────────────────────
export const api = axios.create({
  baseURL: ADMIN_BACKEND_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// ── Ad Mobile EC2 Backend ─────────────────────────────────────────────────────
export const adMobileApi = axios.create({
  baseURL: AD_MOBILE_BACKEND_URL,
  timeout: 120000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token if available
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

adMobileApi.interceptors.request.use(
  (config) => {
    // The Ad Mobile backend uses a different JWT than the Spring Boot admin backend.
    // We prioritize a dedicated token (from env or localStorage) if available.
    const token =
      import.meta.env.VITE_AD_MOBILE_TOKEN ||
      localStorage.getItem('ad_mobile_token') || '';


    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized - redirect to login
      localStorage.removeItem('admin_token');
      localStorage.removeItem('admin_user');
      window.location.href = '/admin/login';
    }
    return Promise.reject(error);
  }
);

export interface ApiResponse<T = any> {
  user?: Record<string, any>;  // returned by Spring Boot login
  token?: string;               // returned by Spring Boot login
  success: boolean;
  message: string;
  data?: T;
  error?: string;
  status?: string;
  rejectionReason?: string;
}

export interface Company {
  _id: string;
  name: string;
  companyLogo?: string | {
    _id?: string;
    mediaKey?: string;
    url?: string;
    s3Location?: string;
  };
  companyType?: string;
}

export interface CompanyRegistrationPayload {
  name: string;
  email: string;
  companyType: string;
  phoneNumber: {
    countryCode: string;
    dialNumber: string;
  };
  companyLogo?: string;
  companyCategories?: string[];
  tax?: {
    taxType: string;
    taxNumber: string;
  };
  billingAddress: {
    addressLine1: string;
    addressLine2?: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  primaryContact: {
    name: string;
    email: string;
    isSameAsBilling: boolean;
    phoneNumber: {
      countryCode: string;
      dialNumber: string;
    };
    alternativePhone?: {
      countryCode: string;
      dialNumber: string;
    };
  };
  password?: string;
}

export interface AdminRegistrationData {
  companyName: string;
  authorizedPerson: string;
  businessAddress: string;
  gstNumber?: string;
  mobileNumber: string;
  emailId: string;
  gstCertificate?: File;
  companyRegistrationDoc: File;
  idProof: File;
}

export const adminApi = {
  registerCompany: async (payload: any): Promise<ApiResponse> => {
    try {
      const response = await adMobileApi.post('/v1/company', payload);
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  registerAdmin: async (payload: FormData): Promise<ApiResponse> => {
    try {
      const response = await api.post('/api/admin/register', payload, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  checkRegistrationStatus: async (email: string): Promise<ApiResponse> => {
    try {
      const response = await api.get(`/api/admin/status?email=${encodeURIComponent(email)}`);
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  getAllCompanies: async (): Promise<ApiResponse<Company[]>> => {
    try {
      const response = await api.get('/api/admin/companies');
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  // Email/Password Login
  login: async (identifier: string, password: string): Promise<ApiResponse> => {
    try {
      const response = await api.post('/api/admin/login', {
        identifier,
        password,
      });
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  // OTP Login - Send OTP
  sendOtp: async (mobileNumber: string): Promise<ApiResponse> => {
    try {
      const response = await api.post('/api/admin/send-otp', {
        mobileNumber,
      });
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  // OTP Login - Verify OTP
  verifyOtp: async (mobileNumber: string, otp: string): Promise<ApiResponse> => {
    try {
      const response = await api.post('/api/admin/verify-otp', {
        mobileNumber,
        otp,
      });
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  // Session Management
  validateSession: async (): Promise<ApiResponse> => {
    try {
      const response = await api.get('/api/admin/validate-session');
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },

  logout: async (): Promise<ApiResponse> => {
    try {
      const response = await api.post('/api/admin/logout');
      return response.data;
    } catch (error: any) {
      if (error.response?.data) {
        return error.response.data;
      }
      throw error;
    }
  },
};