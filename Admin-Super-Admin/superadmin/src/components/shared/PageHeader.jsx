
import React from 'react';

const PageHeader = ({ title, subtitle, actions }) => {
  return (
    <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <div>
        <h1 className="text-3xl font-black text-gray-900 tracking-tight leading-none mb-1">
            <span className="gradient-text">{title}</span>
        </h1>
        {subtitle && <p className="text-sm font-medium text-gray-400 tracking-tight">{subtitle}</p>}
      </div>
      {actions && (
        <div className="flex items-center gap-3">
          {actions}
        </div>
      )}
    </div>
  );
};

export default PageHeader;
