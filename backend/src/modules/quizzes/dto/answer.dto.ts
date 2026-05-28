import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class AnswerDto {
  @ApiProperty()
  @IsString()
  questionId!: string;

  @ApiProperty()
  @IsString()
  optionId!: string;
}
