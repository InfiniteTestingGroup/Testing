import * as React from "react"
import { Check } from "lucide-react"

interface AdStepperProps {
  currentStep: number
  steps: string[]
}

export function AdStepper({ currentStep, steps }: AdStepperProps) {
  return (
    <div className="w-full py-6 mb-8">
      <div className="flex items-center justify-between relative">
        {/* Connecting line */}
        <div className="absolute left-0 top-1/2 -translate-y-1/2 w-full h-1 bg-gray-200 dark:bg-gray-800 rounded-full z-0">
          <div 
            className="h-full bg-brand-500 rounded-full transition-all duration-500 ease-in-out"
            style={{ width: `${(currentStep / (steps.length - 1)) * 100}%` }}
          />
        </div>

        {/* Steps */}
        {steps.map((step, index) => {
          const isCompleted = currentStep > index
          const isActive = currentStep === index

          return (
            <div key={step} className="relative z-10 flex flex-col items-center">
              {/* Circle */}
              <div 
                className={`w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm transition-all duration-300 shadow-sm border-2 ${
                  isCompleted 
                    ? "bg-brand-500 border-brand-500 text-white" 
                    : isActive 
                      ? "bg-white dark:bg-[#1A1D24] border-brand-500 text-brand-600 dark:text-brand-400" 
                      : "bg-white dark:bg-[#1C1F26] border-gray-300 dark:border-gray-700 text-gray-400 dark:text-gray-500"
                }`}
              >
                {isCompleted ? <Check className="w-5 h-5" /> : index + 1}
              </div>
              
              {/* Label */}
              <span 
                className={`absolute top-12 text-xs font-semibold whitespace-nowrap transition-colors duration-300 ${
                  isActive || isCompleted 
                    ? "text-gray-900 dark:text-white" 
                    : "text-gray-500 dark:text-gray-500"
                }`}
              >
                {step}
              </span>
            </div>
          )
        })}
      </div>
    </div>
  )
}
