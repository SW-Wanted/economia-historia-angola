import { Fragment } from 'react'

interface CadastroStepperProps {
  currentStep: 1 | 2 | 3
}

const STEPS = [
  { label: 'Dados' },
  { label: 'Interesses' },
  { label: 'Segurança' },
]

export default function CadastroStepper({ currentStep }: CadastroStepperProps) {
  return (
    <div className="flex items-start justify-center w-full">
      {STEPS.map((step, idx) => {
        const n = (idx + 1) as 1 | 2 | 3
        const done = n < currentStep
        const active = n === currentStep

        return (
          <Fragment key={n}>
            <div className="flex flex-col items-center gap-1.5 flex-shrink-0">
              <div
                className={[
                  'w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold font-sans transition-all duration-300',
                  done
                    ? 'bg-primary text-white'
                    : active
                      ? 'bg-primary text-white ring-[3px] ring-primary/20'
                      : 'bg-surface-container-high text-text-muted',
                ].join(' ')}
              >
                {done ? (
                  <span
                    className="material-symbols-outlined"
                    style={{ fontSize: '14px', fontVariationSettings: "'FILL' 1" }}
                  >
                    check
                  </span>
                ) : (
                  n
                )}
              </div>
              <span
                className={[
                  'text-[9px] font-sans font-bold tracking-[0.07em] uppercase transition-colors duration-300',
                  active ? 'text-primary' : done ? 'text-primary/60' : 'text-outline',
                ].join(' ')}
              >
                {step.label}
              </span>
            </div>

            {idx < STEPS.length - 1 && (
              <div
                className={[
                  'flex-1 h-px mt-4 mx-2 transition-all duration-500',
                  done ? 'bg-primary' : 'bg-outline-variant/45',
                ].join(' ')}
              />
            )}
          </Fragment>
        )
      })}
    </div>
  )
}
