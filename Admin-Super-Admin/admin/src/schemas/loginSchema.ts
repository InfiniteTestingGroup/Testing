import { z } from 'zod';

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MOBILE_REGEX = /^[6-9]\d{9}$/;
const OTP_REGEX = /^\d{6}$/;

// Email/Password login schema
export const emailPasswordLoginSchema = z.object({
  identifier: z.string()
    .min(1, 'Email or mobile number is required')
    .refine((val) => EMAIL_REGEX.test(val) || MOBILE_REGEX.test(val), {
      message: 'Enter a valid email or 10-digit mobile number',
    }),
  password: z.string()
    .min(1, 'Password is required'),
});

// OTP login step 1 schema (mobile number)
export const otpLoginStep1Schema = z.object({
  mobileNumber: z.string()
    .min(1, 'Mobile number is required')
    .regex(MOBILE_REGEX, 'Mobile number must be 10 digits starting with 6-9'),
});

// OTP login step 2 schema (OTP verification)
export const otpLoginStep2Schema = z.object({
  mobileNumber: z.string()
    .min(1, 'Mobile number is required')
    .regex(MOBILE_REGEX, 'Mobile number must be 10 digits starting with 6-9'),
  otp: z.string()
    .min(1, 'OTP is required')
    .regex(OTP_REGEX, 'OTP must be 6 digits'),
});

export type EmailPasswordLoginFormData = z.infer<typeof emailPasswordLoginSchema>;
export type OtpLoginStep1FormData = z.infer<typeof otpLoginStep1Schema>;
export type OtpLoginStep2FormData = z.infer<typeof otpLoginStep2Schema>;

// API Response Types
export interface LoginResponse {
  success: boolean;
  message: string;
  data?: {
    token: string;
    user: {
      id: string;
      email: string;
      mobileNumber: string;
      status: 'Approved' | 'Pending' | 'Rejected';
    };
  };
  error?: string;
}

export interface OtpResponse {
  success: boolean;
  message: string;
  data?: {
    otpId: string;
    expiresIn: number;
  };
  error?: string;
}

export interface OtpVerifyResponse {
  success: boolean;
  message: string;
  data?: {
    token: string;
    user: {
      id: string;
      email: string;
      mobileNumber: string;
      status: 'Approved' | 'Pending' | 'Rejected';
    };
  };
  error?: string;
}
