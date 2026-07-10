import { useState, useRef } from 'react';
import type { UseFormRegister, FieldErrors, Path } from 'react-hook-form';

interface FileUploadProps<T extends Record<string, any>> {
  label: string;
  name: Path<T>;
  register: UseFormRegister<T>;
  errors?: FieldErrors<T>;
  required?: boolean;
  accept?: string;
  className?: string;
}

export function FileUpload<T extends Record<string, any>>({
  label,
  name,
  register,
  errors,
  required = false,
  accept = '.pdf,.jpg,.jpeg,.png',
  className = '',
}: FileUploadProps<T>) {
  const [fileName, setFileName] = useState<string>('');
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  const error = errors?.[name];

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    setFileName(file ? file.name : '');
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    
    const files = e.dataTransfer.files;
    if (files.length > 0 && fileInputRef.current) {
      fileInputRef.current.files = files;
      const event = new Event('change', { bubbles: true });
      fileInputRef.current.dispatchEvent(event);
      setFileName(files[0].name);
    }
  };

  const handleClick = () => {
    fileInputRef.current?.click();
  };

  return (
    <div className={`space-y-1 ${className}`}>
      <label className="block text-sm font-medium text-gray-700">
        {label}
        {required && <span className="text-red-500 ml-1">*</span>}
      </label>
      
      <div
        onClick={handleClick}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onDrop={handleDrop}
        className={`
          relative border-2 border-dashed rounded-lg p-4 text-center cursor-pointer
          transition-colors duration-200
          ${isDragging 
            ? 'border-blue-500 bg-blue-50' 
            : error 
              ? 'border-red-300 bg-red-50 hover:border-red-400' 
              : 'border-gray-300 bg-gray-50 hover:border-gray-400 hover:bg-gray-100'
          }
        `}
      >
        <input
          type="file"
          accept={accept}
          {...register(name)}
          ref={(e) => {
            fileInputRef.current = e;
            register(name).ref(e);
          }}
          onChange={(e) => {
            register(name).onChange(e);
            handleFileChange(e);
          }}
          className="sr-only"
        />
        
        <div className="space-y-2">
          <div className="flex justify-center">
            <svg
              className={`w-8 h-8 ${isDragging ? 'text-blue-500' : error ? 'text-red-500' : 'text-gray-400'}`}
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
              />
            </svg>
          </div>
          
          <div>
            <p className="text-sm text-gray-600">
              {fileName ? (
                <span className="font-medium text-gray-900">{fileName}</span>
              ) : (
                <>
                  <span className="font-medium">Click to upload</span> or drag and drop
                </>
              )}
            </p>
            <p className="text-xs text-gray-500 mt-1">
              PDF, JPG, PNG up to 5MB
            </p>
          </div>
        </div>
      </div>
      
      {error && (
        <p className="text-sm text-red-600">
          {typeof error.message === 'string' ? error.message : 'This field is required'}
        </p>
      )}
    </div>
  );
}
