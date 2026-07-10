import { Moon, Sun } from "lucide-react"
import { useTheme } from "../../context/ThemeContext"

export function ThemeToggle() {
  const { theme, toggleTheme } = useTheme()

  return (
    <button
      onClick={toggleTheme}
      className="p-2 bg-orange-500 rounded-full text-white shadow-lg shadow-orange-500/20 hover:bg-orange-600 transition-all active:scale-95"
      aria-label="Toggle theme"
    >
      {theme === "light" ? (
        <Moon className="w-5 h-5" />
      ) : (
        <Sun className="w-5 h-5" />
      )}
    </button>
  )
}
