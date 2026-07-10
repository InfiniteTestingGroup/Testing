import { z } from "zod"

export const adSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters").max(100, "Title is too long"),
  description: z.string().min(10, "Description must be at least 10 characters").max(500, "Description is too long"),
  type: z.enum(["Banner", "Video", "Image Ad"]),
  companyUID: z.string().optional(),
  mediaFile: z.any().optional(),
  mediaUrl: z.string().optional(),

  ctaType: z.enum(["Redirect", "Dial", "WhatsApp", "Email", "Map"]),
  ctaLabel: z.string().min(1, "Button label is required"),
  ctaActionValue: z.string().min(1, "Action value is required"),

  customSections: z.array(z.object({
    title: z.string().min(1, "Section title is required"),
    description: z.string().min(1)
  })).min(1, "At least one section is required"),

  locationMode: z.enum(["manual", "auto", "preset"]),
  latitude: z.number({ error: "Latitude must be a valid number" })
    .min(-90, "Latitude must be at least -90")
    .max(90, "Latitude must be at most 90")
    .refine((val) => val !== 0, { message: "Latitude is required and cannot be 0" }),
  longitude: z.number({ error: "Longitude must be a valid number" })
    .min(-180, "Longitude must be at least -180")
    .max(180, "Longitude must be at most 180")
    .refine((val) => val !== 0, { message: "Longitude is required and cannot be 0" }),
  radius: z.number({ error: "Radius must be a valid number" }).min(0.1, "Radius must be at least 0.1 KM").max(500, "Maximum radius is 500 KM"),
}).superRefine((data, ctx) => {
  const { ctaType, ctaActionValue } = data

  if (!ctaActionValue?.trim()) return // already caught by min(1) above

  switch (ctaType) {
    case "Dial":
    case "WhatsApp": {
      if (!/^\d{10}$/.test(ctaActionValue)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["ctaActionValue"],
          message: "Enter a valid 10-digit phone number",
        })
      }
      break
    }

    case "Email": {
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(ctaActionValue.trim())) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["ctaActionValue"],
          message: "Enter a valid email address",
        })
      }
      break
    }

    case "Redirect": {
      try {
        new URL(ctaActionValue.trim())
      } catch {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["ctaActionValue"],
          message: "Enter a valid URL (include https://)",
        })
      }
      break
    }

    case "Map": {
      const parts = ctaActionValue.split(",").map((s) => s.trim())
      const lat = parseFloat(parts[0])
      const lng = parseFloat(parts[1])
      const invalid =
        parts.length !== 2 ||
        isNaN(lat) || isNaN(lng) ||
        lat < -90 || lat > 90 ||
        lng < -180 || lng > 180

      if (invalid) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["ctaActionValue"],
          message: "Enter valid coordinates as: lat, lng (e.g. 19.0760, 72.8777)",
        })
      }
      break
    }
  }
})

export type AdFormData = z.infer<typeof adSchema>