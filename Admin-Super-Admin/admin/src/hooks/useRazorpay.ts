import * as React from "react"
import toast from "react-hot-toast"

declare global {
  interface Window {
    Razorpay: any
  }
}

export interface RazorpayHookOptions {
  /** Standard Razorpay options object */
  key?: string
  amount?: number
  currency?: string
  name?: string
  description?: string
  order_id?: string
  handler?: (response: any) => void
  prefill?: Record<string, any>
  theme?: Record<string, any>
  modal?: {
    ondismiss?: () => void
    [key: string]: any
  }
  [key: string]: any
}

export function useRazorpay() {
  const [isLoaded, setIsLoaded] = React.useState(false)

  const loadScript = () => {
    return new Promise((resolve) => {
      if (window.Razorpay) {
        setIsLoaded(true)
        resolve(true)
        return
      }
      const script = document.createElement("script")
      script.src = "https://checkout.razorpay.com/v1/checkout.js"
      script.onload = () => {
        setIsLoaded(true)
        resolve(true)
      }
      script.onerror = () => {
        setIsLoaded(false)
        resolve(false)
      }
      document.body.appendChild(script)
    })
  }

  /**
   * Opens the Razorpay checkout modal.
   *
   * @param options  Standard Razorpay checkout options.
   * @param onFailure  Optional callback fired when Razorpay emits `payment.failed`.
   *                   Receives the Razorpay error response object.
   * @returns The Razorpay instance, so callers can attach additional listeners
   *          or call rzp.close() if needed.
   */
  const initiatePayment = async (
    options: RazorpayHookOptions,
    onFailure?: (response: any) => void
  ) => {
    if (!window.Razorpay) {
      const loaded = await loadScript()
      if (!loaded) {
        const msg = "Failed to load Razorpay SDK. Please check your internet connection and try again."
        toast.error(msg)
        throw new Error(msg)
      }
    }

    const rzp = new window.Razorpay(options)

    // Wire up the payment.failed listener if a callback was provided
    if (onFailure) {
      rzp.on("payment.failed", (response: any) => {
        onFailure(response)
      })
    }

    rzp.open()
    return rzp
  }

  return { isLoaded, loadScript, initiatePayment }
}
