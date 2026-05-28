import { PermissionCode } from '@prisma/client';
import { SetMetadata } from '@nestjs/common';

export const PERMISSIONS_KEY = 'permissions';
export const Permissions = (...permissions: PermissionCode[]) => SetMetadata(PERMISSIONS_KEY, permissions);
