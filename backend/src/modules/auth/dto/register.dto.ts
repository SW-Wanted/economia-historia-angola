import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty()
  @IsString()
  name!: string;

  @ApiProperty()
  @IsEmail()
  email!: string;

  @ApiProperty()
  @IsString()
  @MinLength(8)
  password!: string;

  @ApiProperty({ description: 'Course or study area (required for statistical analysis)' })
  @IsString()
  course!: string;

  @ApiProperty({ description: 'Motivation for interest in economics and history' })
  @IsString()
  motivation!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  username?: string;
}
