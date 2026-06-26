import type { Config } from 'tailwindcss'

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#8B1A1A',
          dark: '#6E1414',
          light: '#A52020',
        },
        'primary-container': '#FFE9E6',
        'primary-fixed': '#FFDAD6',

        background: '#F4F2F0',
        surface: '#FFFFFF',
        'surface-warm': '#FFF8F6',
        'surface-low': '#FFF0EE',
        'surface-container': '#FFE9E6',
        'surface-container-lowest': '#FFFFFF',
        'surface-container-low': '#FFF4F2',
        'surface-container-high': '#F7DEDA',
        'surface-container-highest': '#F0D4D1',
        'surface-dim': '#E8CECA',
        'surface-tint': '#8B1A1A',
        'surface-elevated': '#FEFEFE',

        text: '#1A0F0F',
        'text-muted': '#5C4040',
        secondary: '#626262',
        'on-primary': '#FFFFFF',
        'on-surface': '#1A0F0F',
        'on-surface-variant': '#5C4040',
        'on-background': '#1A0F0F',
        'on-error': '#FFFFFF',
        'on-secondary': '#FFFFFF',
        'inverse-surface': '#362F2E',
        'inverse-on-surface': '#FFF0EF',
        'inverse-primary': '#FFB3AC',

        outline: '#8A706D',
        'outline-variant': '#DEB8B5',

        error: '#B00020',
        'error-container': '#FFD9D9',
        success: '#1B6B3A',
        'success-container': '#D4EDDA',
        warning: '#B45309',
        'warning-container': '#FEF3C7',

        navy: '#1E3A5F',
        'navy-container': '#D0E4F7',
        tertiary: '#7A4800',
        'tertiary-fixed': '#FFE4C4',
        gold: '#C9860D',
        'gold-container': '#FEF3C7',
      },

      borderRadius: {
        DEFAULT: '0.375rem',
        sm: '0.25rem',
        md: '0.5rem',
        button: '0.5rem',
        lg: '0.75rem',
        xl: '1rem',
        '2xl': '1.25rem',
        card: '1rem',
        '3xl': '1.5rem',
        full: '9999px',
      },

      boxShadow: {
        xs: '0 1px 2px 0 rgba(0,0,0,0.05)',
        sm: '0 1px 3px 0 rgba(0,0,0,0.07), 0 1px 2px -1px rgba(0,0,0,0.04)',
        DEFAULT: '0 2px 8px 0 rgba(0,0,0,0.08), 0 1px 3px -1px rgba(0,0,0,0.05)',
        md: '0 4px 12px -2px rgba(0,0,0,0.10), 0 2px 4px -2px rgba(0,0,0,0.06)',
        lg: '0 8px 24px -4px rgba(0,0,0,0.13), 0 4px 8px -4px rgba(0,0,0,0.07)',
        xl: '0 16px 40px -8px rgba(0,0,0,0.16), 0 8px 16px -8px rgba(0,0,0,0.08)',
        card: '0 1px 2px rgba(0,0,0,0.04), 0 3px 10px rgba(0,0,0,0.07)',
        'card-hover': '0 4px 16px rgba(0,0,0,0.11), 0 2px 6px rgba(0,0,0,0.06)',
        hero: '0 20px 60px rgba(139,26,26,0.20), 0 8px 24px rgba(0,0,0,0.10)',
        inner: 'inset 0 2px 4px 0 rgba(0,0,0,0.05)',
        glow: '0 0 0 3px rgba(139,26,26,0.15)',
        none: 'none',
      },

      spacing: {
        'sidebar': '272px',
        'topbar': '64px',
        'max-content': '1200px',
      },

      fontFamily: {
        sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'],
        heading: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'],
        body: ['Lexend', 'system-ui', 'sans-serif'],
        reading: ['Merriweather', 'Georgia', 'serif'],
        serif: ['Merriweather', 'Georgia', 'serif'],
      },

      fontSize: {
        'display': ['52px', { lineHeight: '1.05', letterSpacing: '-0.025em', fontWeight: '800' }],
        'display-xl': ['44px', { lineHeight: '1.08', letterSpacing: '-0.022em', fontWeight: '800' }],
        'display-web': ['38px', { lineHeight: '1.12', letterSpacing: '-0.020em', fontWeight: '800' }],
        'display-lg': ['30px', { lineHeight: '1.2', letterSpacing: '-0.018em', fontWeight: '800' }],
        'headline-xl': ['26px', { lineHeight: '1.25', letterSpacing: '-0.012em', fontWeight: '700' }],
        'headline-lg': ['22px', { lineHeight: '1.28', letterSpacing: '-0.010em', fontWeight: '700' }],
        'headline-md': ['18px', { lineHeight: '1.35', letterSpacing: '-0.006em', fontWeight: '700' }],
        'title-lg': ['16px', { lineHeight: '1.4', fontWeight: '600' }],
        'title-md': ['14px', { lineHeight: '1.42', fontWeight: '600' }],
        'body-xl': ['18px', { lineHeight: '1.7', fontWeight: '400' }],
        'body-lg': ['16px', { lineHeight: '1.6', fontWeight: '400' }],
        'body-md': ['14px', { lineHeight: '1.5', fontWeight: '400' }],
        'body-sm': ['13px', { lineHeight: '1.45', fontWeight: '400' }],
        'label-lg': ['13px', { lineHeight: '1.3', letterSpacing: '0.01em', fontWeight: '600' }],
        'label-md': ['11px', { lineHeight: '1.3', letterSpacing: '0.04em', fontWeight: '700' }],
        'label-sm': ['10px', { lineHeight: '1.2', letterSpacing: '0.06em', fontWeight: '700' }],
        'body-reading': ['17px', { lineHeight: '1.85', fontWeight: '400' }],
      },

      animation: {
        'fade-in': 'fadeIn 0.25s ease-out',
        'slide-up': 'slideUp 0.35s cubic-bezier(0.16, 1, 0.3, 1)',
        'scale-in': 'scaleIn 0.2s cubic-bezier(0.16, 1, 0.3, 1)',
        'pulse-soft': 'pulseSoft 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'shimmer': 'shimmer 1.8s infinite',
      },

      keyframes: {
        fadeIn: {
          from: { opacity: '0' },
          to: { opacity: '1' },
        },
        slideUp: {
          from: { opacity: '0', transform: 'translateY(10px)' },
          to: { opacity: '1', transform: 'translateY(0)' },
        },
        scaleIn: {
          from: { opacity: '0', transform: 'scale(0.96)' },
          to: { opacity: '1', transform: 'scale(1)' },
        },
        pulseSoft: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.5' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
      },

      transitionTimingFunction: {
        smooth: 'cubic-bezier(0.4, 0, 0.2, 1)',
        spring: 'cubic-bezier(0.16, 1, 0.3, 1)',
        snappy: 'cubic-bezier(0.2, 0, 0, 1)',
      },
    },
  },
  plugins: [],
} satisfies Config
