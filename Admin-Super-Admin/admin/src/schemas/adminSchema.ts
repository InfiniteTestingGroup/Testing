import { z } from 'zod';

const GST_REGEX = /^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/;
const MOBILE_REGEX = /^[6-9]\d{9}$/;

const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const ALLOWED_FILE_TYPES = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png'];

export const adminRegistrationSchema = z.object({
  // Company Information
  companyName: z.string().min(1, 'Company name is required'),
  authorizedPerson: z.string().min(1, 'Authorized person name is required'),
  businessAddress: z.string().min(1, 'Business address is required'),
  gstNumber: z.string()
    .optional()
    .refine((val) => !val || GST_REGEX.test(val), {
      message: 'Invalid GST number format',
    }),

  // Contact Information
  mobileNumber: z.string()
    .min(1, 'Mobile number is required')
    .regex(MOBILE_REGEX, 'Mobile number must be 10 digits starting with 6-9'),
  emailId: z.string()
    .min(1, 'Email is required')
    .email('Invalid email format'),

  // Document Uploads
  gstCertificate: z.instanceof(File)
    .optional()
    .refine((file) => {
      if (!file) return true;
      return ALLOWED_FILE_TYPES.includes(file.type);
    }, 'Only PDF, JPG, PNG files are allowed')
    .refine((file) => {
      if (!file) return true;
      return file.size <= MAX_FILE_SIZE;
    }, 'File size must be less than 5MB'),

  companyRegistrationDoc: z.instanceof(File)
    .refine((file) => !!file, 'Company registration document is required')
    .refine((file) => ALLOWED_FILE_TYPES.includes(file.type), 'Only PDF, JPG, PNG files are allowed')
    .refine((file) => file.size <= MAX_FILE_SIZE, 'File size must be less than 5MB'),

  idProof: z.instanceof(File)
    .refine((file) => !!file, 'ID proof is required')
    .refine((file) => ALLOWED_FILE_TYPES.includes(file.type), 'Only PDF, JPG, PNG files are allowed')
    .refine((file) => file.size <= MAX_FILE_SIZE, 'File size must be less than 5MB'),
}).refine((data) => {
  // If GST number is provided, GST certificate is required
  if (data.gstNumber && !data.gstCertificate) {
    return false;
  }
  return true;
}, {
  message: 'GST certificate is required when GST number is provided',
  path: ['gstCertificate'],
});

export type AdminRegistrationFormData = z.infer<typeof adminRegistrationSchema>;
