/**
 * Renders an extracted HTML screen inside an iframe-like full-page container.
 * The HTML is injected as raw markup so all Tailwind CDN classes work as-is.
 */
interface HtmlScreenProps {
  html: string
}

export default function HtmlScreen({ html }: HtmlScreenProps) {
  return (
    <div
      className="w-full min-h-screen"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  )
}
