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

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  username?: string;

  @ApiPropertyOptional({ description: 'Field of study or course (used for content personalisation)' })
  @IsOptional()
  @IsString()
  course?: string;

  @ApiPropertyOptional({ description: 'Comma-separated interest topics selected during onboarding (e.g. "Agricultura,Finanças")' })
  @IsOptional()
  @IsString()
  interests?: string;

  @ApiPropertyOptional({ description: 'Why the user joined the platform (optional, free text)' })
  @IsOptional()
  @IsString()
  motivation?: string;
}
