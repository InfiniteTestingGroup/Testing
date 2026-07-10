import { z } from "zod";

export const publisherSchema = z.object({
  name: z.string().min(2, "Publisher Name must be at least 2 characters"),
  contactPerson: z.string().min(2, "Contact Person is required"),
  email: z.string().email("Invalid email format"),
  mobile: z.string().regex(/^\d{10}$/, "Mobile number must be exactly 10 digits"),
  address: z.string().min(5, "Address must be at least 5 characters"),
  latitude: z.coerce.number({ message: "Latitude must be a valid number" }).min(-90, "Invalid latitude").max(90, "Invalid latitude"),
  longitude: z.coerce.number({ message: "Longitude must be a valid number" }).min(-180, "Invalid longitude").max(180, "Invalid longitude"),
});

export type PublisherFormData = z.infer<typeof publisherSchema>;
