---
paths:
  - 'apps/mobile/**/*.tsx'
  - 'apps/mobile/**/*.ts'
---

# Expo Mobile Rules

## Structure

```
app/                    Expo Router screens
components/             UI components
  Button.tsx
  Card.tsx
  FormField.tsx
hooks/                  Custom hooks
lib/                    Utilities
  api-client.ts
  storage.ts
providers/              Context providers
theme/                  Design tokens
  tokens.ts
```

## Component Pattern

```tsx
import { StyleSheet, View, Text } from 'react-native';

interface CardProps {
  title: string;
  children: React.ReactNode;
}

export function Card({ title, children }: CardProps) {
  return (
    <View style={styles.card}>
      <Text style={styles.title}>{title}</Text>
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 16, borderRadius: 8, backgroundColor: '#fff' },
  title: { fontSize: 18, fontWeight: '600' },
});
```

## Form Pattern

```tsx
import { Controller } from 'react-hook-form';

<Controller
  control={control}
  name="email"
  render={({ field, fieldState }) => (
    <FormField
      label="Email"
      value={field.value}
      onChangeText={field.onChange}
      error={fieldState.error?.message}
    />
  )}
/>;
```

## Auth Storage

```typescript
import * as SecureStore from 'expo-secure-store';

await SecureStore.setItemAsync('accessToken', token);
const token = await SecureStore.getItemAsync('accessToken');
await SecureStore.deleteItemAsync('accessToken');
```

## Navigation

```tsx
// app/(auth)/login.tsx      - Guest only
// app/(app)/dashboard.tsx   - Protected
// app/(app)/_layout.tsx     - Auth check

import { useSegments, useRouter } from 'expo-router';

// Auth redirect in AuthProvider
useEffect(() => {
  const inAuthGroup = segments[0] === '(auth)';
  if (!user && !inAuthGroup) router.replace('/login');
  if (user && inAuthGroup) router.replace('/dashboard');
}, [user, segments]);
```

## Styling Rules

- Use `StyleSheet.create()` for performance
- Design tokens in `theme/tokens.ts`
- 48px minimum touch targets
- Platform-specific styles with `Platform.select()`
