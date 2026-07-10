import { z } from "zod"

export const publishSchema = z.object({
  startDate: z.string().min(1, "Start date is required"),
  endDate: z.string().min(1, "End date is required"),
  publisherIds: z.array(z.string()).min(1, "At least one publisher must be assigned"),
}).refine((data) => {
  if (!data.startDate || !data.endDate) return true
  return new Date(data.endDate) > new Date(data.startDate)
}, {
  message: "End date must be after start date",
  path: ["endDate"]
})

export type PublishFormData = z.infer<typeof publishSchema>
