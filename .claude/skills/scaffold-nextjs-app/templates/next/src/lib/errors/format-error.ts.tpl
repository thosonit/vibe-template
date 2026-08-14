import { AppError } from './app-error'

export function formatError(error: unknown): string {
  if (error instanceof AppError) {
    return error.message
  }
  return 'Something went wrong. Please try again.'
}
