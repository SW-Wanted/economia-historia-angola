export type DomainEvent<TPayload extends object = object> = {
  name: string;
  aggregateId: string;
  payload: TPayload;
  occurredAt: Date;
};
