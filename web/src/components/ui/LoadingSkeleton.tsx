interface LoadingSkeletonProps {
  className?: string
}

export default function LoadingSkeleton({ className = '' }: LoadingSkeletonProps) {
  return (
    <div
      className={`bg-surface-container-high animate-pulse rounded-card ${className}`}
    />
  )
}
