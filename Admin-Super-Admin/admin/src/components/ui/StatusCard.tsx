import { Button } from './Button';

export type RegistrationStatus = 'pending' | 'approved' | 'rejected';

interface StatusCardProps {
  status: RegistrationStatus;
  reason?: string;
  onGoToLogin?: () => void;
  onReApply?: () => void;
  isLoading?: boolean;
}

export function StatusCard({
  status,
  reason,
  onGoToLogin,
  onReApply,
  isLoading = false,
}: StatusCardProps) {
  const getStatusConfig = () => {
    switch (status) {
      case 'pending':
        return {
          icon: (
            <svg className="w-16 h-16 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
          ),
          title: 'Your registration is under review',
          subtitle: 'You will be notified via email once approved',
          bgColor: 'bg-blue-50',
          borderColor: 'border-blue-200',
          textColor: 'text-blue-800',
        };
      case 'approved':
        return {
          icon: (
            <svg className="w-16 h-16 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
          ),
          title: 'Your account has been approved',
          subtitle: 'You can now log in to your account',
          bgColor: 'bg-green-50',
          borderColor: 'border-green-200',
          textColor: 'text-green-800',
        };
      case 'rejected':
        return {
          icon: (
            <svg className="w-16 h-16 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
          ),
          title: 'Your registration was rejected',
          subtitle: reason || 'Your registration could not be approved at this time',
          bgColor: 'bg-red-50',
          borderColor: 'border-red-200',
          textColor: 'text-red-800',
        };
      default:
        return {
          icon: null,
          title: 'Unknown status',
          subtitle: 'Please contact support',
          bgColor: 'bg-gray-50',
          borderColor: 'border-gray-200',
          textColor: 'text-gray-800',
        };
    }
  };

  const config = getStatusConfig();

  if (isLoading) {
    return (
      <div className="bg-white rounded-lg shadow-lg p-8 text-center">
        <div className="flex justify-center items-center h-32">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>
        <p className="text-gray-600 mt-4">Checking your registration status...</p>
      </div>
    );
  }

  return (
    <div className={`bg-white rounded-lg shadow-lg overflow-hidden`}>
      {/* Status Header */}
      <div className={`${config.bgColor} ${config.borderColor} border-b-2 px-8 py-6`}>
        <div className="flex items-center justify-center">
          {config.icon}
        </div>
      </div>

      {/* Status Content */}
      <div className="p-8 text-center space-y-6">
        <div>
          <h2 className={`text-2xl font-bold ${config.textColor} mb-2`}>
            {config.title}
          </h2>
          <p className="text-gray-600 text-lg">
            {config.subtitle}
          </p>
        </div>

        {/* Additional details for rejected status */}
        {status === 'rejected' && reason && (
          <div className="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
            <h3 className="font-semibold text-red-800 mb-2">Reason:</h3>
            <p className="text-red-700 text-sm">{reason}</p>
          </div>
        )}

        {/* Action Buttons */}
        <div className="pt-6 space-y-3">
          {status === 'approved' && onGoToLogin && (
            <Button
              onClick={onGoToLogin}
              variant="primary"
              size="lg"
              className="w-full"
            >
              Go to Login
            </Button>
          )}

          {status === 'rejected' && onReApply && (
            <div className="space-y-3">
              <Button
                onClick={onReApply}
                variant="primary"
                size="lg"
                className="w-full"
              >
                Re-Apply
              </Button>
              <p className="text-sm text-gray-500">
                You can submit a new registration application
              </p>
            </div>
          )}

          {status === 'pending' && (
            <div className="space-y-3">
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h3 className="font-semibold text-blue-800 mb-2">What happens next?</h3>
                <ul className="text-blue-700 text-sm space-y-1 text-left">
                  <li>1. Your application is being reviewed by our team</li>
                  <li>2. You'll receive an email notification once a decision is made</li>
                  <li>3. Approved accounts can immediately access the dashboard</li>
                </ul>
              </div>
              <p className="text-sm text-gray-500">
                This page will automatically update when your status changes
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
