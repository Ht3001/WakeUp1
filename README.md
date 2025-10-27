## Monetización

**Valor Humano** genera ingresos mediante:

1. **Modelo Freemium:**  
   - Acceso gratuito limitado.  
   - Suscripción Premium con más preguntas, reportes avanzados y logros exclusivos.

2. **Compras dentro de la app:**  
   - Packs de preguntas premium por categoría.  
   - Mini-cursos de desarrollo personal.

3. **Publicidad opcional:**  
   - Anuncios no intrusivos en la versión gratuita.  
   - Eliminación de anuncios para suscriptores Premium.

4. **Licencias para empresas o coaches:**  
   - Uso de la app con empleados o clientes mediante licencias pagas.

### Integración técnica
- **Stripe:** Suscripciones y pagos dentro de la app.  
- **Firebase:** Gestión de usuarios, suscripciones y contenido premium.

# WakeUp - Bilingüe (ES/EN)

WakeUp es una aplicación de microaprendizaje ético diseñada para enseñar valores y habilidades en sesiones de 5 minutos.

## Qué incluye este scaffold
- Next.js + Tailwind (config files incluidos)
- Supabase y Stripe placeholders en `.env.example`
- Estructura básica de frontend y backend
- Soporte básico bilingüe (ES / EN) con `locales/*.json`
- Ejemplo de `LanguageSwitcher` y página principal

## Cómo usar
1. Copia `.env.example` a `.env.local` y llena las variables.
2. `npm install`
3. `npm run dev`

## Notas
- Este scaffold incluye ejemplos y placeholders. Necesitarás configurar Supabase, Stripe (modo test) y Accredible para certificados.
