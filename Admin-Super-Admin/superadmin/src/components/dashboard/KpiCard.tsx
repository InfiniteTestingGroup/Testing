import type { ElementType } from 'react';

interface KpiCardProps {
  title: string;
  value: string;
  change?: number;
  changeLabel?: string;
  icon: ElementType;
  iconBg: string;
  iconColor: string;
  prefix?: string;
}

export default function KpiCard({
  title,
  value,
  icon: Icon,
  iconBg,
  iconColor,
  prefix = '',
  changeLabel = '',
}: KpiCardProps) {
  return (
    <div className="glass-card-hover p-5 group animate-fade-in flex flex-col justify-between h-full min-h-[140px]">
      {/* Top row: icon + badge */}
      <div className="flex items-center justify-between mb-4">
        <div className={`w-10 h-10 ${iconBg} rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300 flex-shrink-0`}>
          <Icon size={18} className={iconColor} />
        </div>
      </div>

      {/* Value */}
      <p className="text-[22px] font-bold text-gray-900 tracking-tight leading-none">
        {prefix}{value}
      </p>

      {/* Labels */}
      <p className="text-[13px] font-medium text-gray-600 mt-1.5">{title}</p>
      {changeLabel && (
        <p className="text-[11px] text-gray-400 mt-0.5 truncate">{changeLabel}</p>
      )}
    </div>
  );
}
