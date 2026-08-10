---
name: debug-api
description: Debug NestJS API issues with logs, errors, and tracing. Use when an API endpoint fails, returns 4xx/5xx, guards block access, or Prisma/database errors appear.
---

Debug the reported API issue (error message, endpoint, or stack trace from the user).

## Debug Steps

1. **Identify the error**
   - Check terminal/console for stack traces
   - Note the HTTP status code
   - Identify the endpoint

2. **Trace the flow**

   ```
   Controller → Service → Repository → Prisma
   ```

3. **Common issues**
   - 401: Check AccessTokenGuard, @Public() decorator
   - 403: Check @Roles() decorator, RolesGuard
   - 404: Check route path, entity existence
   - 500: Check Prisma queries, null references

4. **Check guards**
   - Is route marked @Public()?
   - Are roles correct?
   - Is token valid?

5. **Check database**
   - Run `pnpm db:studio` to inspect data
   - Check Prisma query syntax
   - Verify relations

6. **Add logging**

   ```typescript
   console.log('Debug:', { variable });
   ```

7. **Test fix**
   - Use REST client or Swagger at /api/docs
   - Verify response
