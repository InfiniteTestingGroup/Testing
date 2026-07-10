import { useState, useRef, useEffect } from 'react';
import type { UseFormRegister, FieldErrors, Path } from 'react-hook-form';

interface OtpInputProps<T extends Record<string, any>> {
  name: Path<T>;
  register: UseFormRegister<T>;
  errors: FieldErrors<T>;
  length?: number;
  disabled?: boolean;
  className?: string;
  onOtpComplete?: (otp: string) => void;
}

export function OtpInput<T extends Record<string, any>>({
  name,
  register,
  errors,
  length = 6,
  disabled = false,
  className = '',
  onOtpComplete,
}: OtpInputProps<T>) {
  const [otpValues, setOtpValues] = useState<string[]>(Array(length).fill(''));
  const inputRefs = useRef<(HTMLInputElement | null)[]>(Array(length).fill(null));
  
  const error = errors[name];

  const handleChange = (index: number, value: string) => {
    // Only allow digits
    if (!/^\d*$/.test(value)) return;
    
    const newOtpValues = [...otpValues];
    newOtpValues[index] = value.slice(-1); // Take only last character
    setOtpValues(newOtpValues);

    // Auto-focus next input
    if (value && index < length - 1) {
      inputRefs.current[index + 1]?.focus();
    }

    // Call onOtpComplete if all fields are filled
    const completeOtp = newOtpValues.join('');
    if (completeOtp.length === length && onOtpComplete) {
      onOtpComplete(completeOtp);
    }

    // Update form value
    const event = new Event('input', { bubbles: true });
    Object.defineProperty(event, 'target', {
      writable: false,
      value: { ...event.target, value: completeOtp, name },
    });
    register(name).onChange(event);
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    // Handle backspace
    if (e.key === 'Backspace' && !otpValues[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
      const newOtpValues = [...otpValues];
      newOtpValues[index - 1] = '';
      setOtpValues(newOtpValues);
    }
    
    // Handle arrow keys
    if (e.key === 'ArrowLeft' && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
    if (e.key === 'ArrowRight' && index < length - 1) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    e.preventDefault();
    const pastedData = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, length);
    
    if (pastedData) {
      const newOtpValues = [...otpValues];
      for (let i = 0; i < length; i++) {
        newOtpValues[i] = pastedData[i] || '';
      }
      setOtpValues(newOtpValues);
      
      // Focus the next empty input or the last one
      const nextEmptyIndex = newOtpValues.findIndex(val => val === '');
      const focusIndex = nextEmptyIndex === -1 ? length - 1 : nextEmptyIndex;
      inputRefs.current[focusIndex]?.focus();

      // Update form value
      const completeOtp = newOtpValues.join('');
      if (completeOtp.length === length && onOtpComplete) {
        onOtpComplete(completeOtp);
      }
      
      const event = new Event('input', { bubbles: true });
      Object.defineProperty(event, 'target', {
        writable: false,
        value: { ...event.target, value: completeOtp, name },
      });
      register(name).onChange(event);
    }
  };

  // Clear OTP when form is reset
  useEffect(() => {
    register(name);
  }, [name, register]);

  return (
    <div className={`space-y-2 ${className}`}>
      <div className="flex gap-2 justify-center">
        {Array.from({ length }, (_, index) => (
          <input
            key={index}
            ref={(el) => {
              inputRefs.current[index] = el;
            }}
            type="text"
            inputMode="numeric"
            pattern="[0-9]*"
            maxLength={1}
            value={otpValues[index]}
            onChange={(e) => handleChange(index, e.target.value)}
            onKeyDown={(e) => handleKeyDown(index, e)}
            onPaste={handlePaste}
            disabled={disabled}
            className={`
              w-12 h-12 text-center text-lg font-semibold
              border-2 rounded-lg
              focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500
              transition-colors duration-200
              ${error 
                ? 'border-red-500 focus:ring-red-500 focus:border-red-500' 
                : 'border-gray-300 hover:border-gray-400'
              }
              ${disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white'}
            `}
            placeholder="0"
          />
        ))}
      </div>
      
      {error && (
        <p className="text-sm text-red-600 text-center">
          {typeof error.message === 'string' ? error.message : 'Invalid OTP'}
        </p>
      )}
    </div>
  );
}
