---
paths:
  - 'apps/api/**/*.ts'
---

# NestJS API Rules

## Clean Architecture Layers

```
src/presentation/<feature>/     Controllers + DTOs (dto/ subfolder)
src/usecase/<feature>/          Services + Modules (business logic)
src/service/<feature>/          Repositories (data access)
src/orm/                        PrismaService, BaseRepository
```

**Dependency Rule**: Never import upward. Repository cannot import Controller.

## File Patterns

| Type       | Pattern                   | Example                    |
| ---------- | ------------------------- | -------------------------- |
| Controller | `<feature>.controller.ts` | `users.controller.ts`      |
| Service    | `<feature>.service.ts`    | `users.service.ts`         |
| Repository | `<feature>.repository.ts` | `users.repository.ts`      |
| DTO        | `<action>.dto.ts`         | `create-user.dto.ts`       |
| Guard      | `<name>.guard.ts`         | `access-token.guard.ts`    |
| Strategy   | `<name>.strategy.ts`      | `access-token.strategy.ts` |

## Controller Pattern

```typescript
@Controller('users')
@ApiBearerAuth('access-token')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  /** GET /api/v1/users/me */
  @Get('me')
  getMe(@GetCurrentUser() user: JwtPayload) {
    return this.usersService.findById(user.sub);
  }
}
```

## Repository Pattern

```typescript
@Injectable()
export class UsersRepository extends BaseRepository<
  User,
  CreateUserInput,
  UpdateUserInput,
  { id: string }
> {
  constructor(prisma: PrismaService) {
    super(prisma);
  }

  protected get delegate() {
    return this.prisma.user;
  }
}
```

## Guards

- `@Public()` - opt-out of AccessTokenGuard
- `@Roles(Role.ADMIN)` - restrict to roles
- `@UseGuards(RefreshTokenGuard)` - explicit guard

## DTO Validation

```typescript
export class CreateUserDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'password123' })
  @MinLength(8)
  password: string;
}
```

## Module Registration

```typescript
@Module({
  imports: [PrismaModule],
  controllers: [UsersController],
  providers: [UsersService, UsersRepository],
  exports: [UsersService],
})
export class UsersModule {}
```
