export function InputField(props: any) {
  const { label, name, type = "text", placeholder, register } = props;

  return (
    <div className="mb-4">
      {label && <label className="block mb-1">{label}</label>}

      <input
        type={type}
        placeholder={placeholder}
        {...(register ? register(name) : {})}
        className="w-full border border-gray-300 p-2 rounded"
      />
    </div>
  );
}