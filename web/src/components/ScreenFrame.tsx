/**
 * Renders an extracted HTML screen in a full-page iframe.
 * This preserves 100% visual fidelity — all Tailwind CDN, fonts, and scripts
 * from the original HTML work exactly as designed.
 */
interface ScreenFrameProps {
  src: string
  title?: string
}

export default function ScreenFrame({ src, title = 'Screen' }: ScreenFrameProps) {
  return (
    <iframe
      src={src}
      title={title}
      className="w-full border-0"
      style={{ height: '100vh', display: 'block' }}
    />
  )
}
