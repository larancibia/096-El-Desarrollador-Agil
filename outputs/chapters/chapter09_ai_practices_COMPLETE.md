# Capítulo 9: Trabajando con IA - Prácticas Avanzadas

## El Prompt que Cambió el Juego

Ricardo estaba atascado. Necesitaba implementar un sistema de permisos complejo: roles jerárquicos, permisos heredados, excepciones por recurso, temporal grants. Había pasado tres horas leyendo documentación sobre RBAC y ABAC.

Desesperado, abrió ChatGPT y escribió: "Necesito sistema de permisos."

La IA respondió con un ejemplo genérico de RBAC que encontrarías en cualquier tutorial. No ayudó en nada.

Frustrado, Ricardo estaba por cerrar la ventana. Pero entonces recordó algo que había leído: "Los LLMs son tan buenos como tus prompts."

Respiró profundo. Pensó en el problema. Y escribió:

```
Necesito diseñar un sistema de permisos para una plataforma SaaS B2B con estos requisitos específicos:

Contexto:
- Plataforma de project management
- Múltiples organizaciones (tenants)
- Cada org tiene equipos y proyectos
- 5 roles: Owner, Admin, Manager, Member, Guest

Requisitos:
1. Jerarquía de roles (Owner puede todo lo que Admin puede, etc)
2. Permisos se pueden asignar a nivel organización, equipo o proyecto
3. Permisos más específicos overridean permisos generales
4. Algunos permisos son temporales (ej: acceso por 7 días)
5. Audit log de todos los cambios de permisos

Casos edge:
- Un Manager de equipo A puede ser Member de equipo B
- Guest puede tener permiso explícito para proyecto específico
- Owner puede delegar temporarily su rol

Tech stack:
- PostgreSQL para almacenamiento
- Python/Django para backend
- Redis para caching de permisos

Dame:
1. Modelo de base de datos
2. Algoritmo para resolver "¿user X tiene permiso Y en recurso Z?"
3. Consideraciones de performance
4. Manejo de casos edge mencionados
```

La respuesta fue radicalmente diferente. Un diseño completo, pensado, con código específico para su contexto. Tablas de DB bien normalizadas. Algoritmo eficiente con caching. Manejo explícito de cada edge case.

Ricardo implementó el diseño en dos días. Sin el prompt mejorado, habría tomado dos semanas.

La diferencia no fue la IA. Fue el **prompting**.

---

## Sección 1: La Anatomía de un Prompt Efectivo

### El Framework CORE

Un prompt efectivo para desarrollo tiene cuatro componentes:

**C - Context (Contexto)**
¿Qué problema estás resolviendo? ¿Para qué sistema? ¿Qué restricciones existen?

**O - Objective (Objetivo)**
¿Qué quieres específicamente? Código, diseño, explicación, debug, review.

**R - Requirements (Requisitos)**
Funcionales, no-funcionales, edge cases, tech stack.

**E - Examples (Ejemplos)**
Muestra código existente, patrones que sigues, estilo preferido.

### Ejemplo Comparativo

**❌ Prompt Débil:**
```
Cómo hacer autenticación con JWT
```

**✅ Prompt Fuerte (CORE):**
```
[CONTEXT]
Building a REST API for mobile app (React Native). Backend is Node.js/Express.
Currently using basic auth, needs upgrade to JWT for scalability.

[OBJECTIVE]
Implementar autenticación JWT con refresh tokens

[REQUIREMENTS]
- Access tokens: 15 min expiration
- Refresh tokens: 7 days expiration, stored in DB
- Ability to revoke all refresh tokens for a user (logout all devices)
- Password reset should invalidate all tokens
- Protect against XSS (tokens in httpOnly cookies, not localStorage)

[EXAMPLES]
Current auth middleware:
```javascript
function authenticate(req, res, next) {
  const token = req.headers['authorization'];
  // basic validation
}
```

Preferred style: async/await, error handling with try/catch
```

La segunda genera código production-ready. La primera genera tutorial genérico.

---

## Sección 2: Patrones de Prompting Para Developers

### Patrón 1: Iterative Refinement

No esperes perfección en el primer prompt. Refina iterativamente.

**Iteración 1:**
```
Crear una función para calcular descuento en e-commerce
```

**IA responde con algo básico.**

**Iteración 2:**
```
El descuento debe considerar:
- Tier del customer (bronze/silver/gold: 5%/10%/15%)
- Promociones activas (pueden stackearse hasta 30% max)
- Bulk discounts (10+ items: 5%, 50+ items: 10%)
- First-time customer: 20% adicional
```

**IA responde mejor, pero falta validación.**

**Iteración 3:**
```
Agregar validación:
- Amount no puede ser negativo
- Discount final no puede exceder 50% (policy)
- Promociones expired no se aplican
- Retornar error descriptivo si validación falla
```

**Ahora sí: código production-ready.**

### Patrón 2: Role-Playing

Asigna un rol específico a la IA.

```
Actúa como un senior backend engineer especializado en sistemas distribuidos.

Tengo este problema: [...]

Analiza la solución como lo haría un arquitecto experimentado:
- Identifica trade-offs
- Sugiere alternativas
- Señala problemas potenciales
- Recomienda best practices
```

La IA adopta ese "mindset" y da respuestas más profundas.

### Patrón 3: Constrained Generation

Limita la respuesta para obtener exactamente lo que necesitas.

```
Dame SOLO el código Python, sin explicación.
Usa type hints.
Máximo 50 líneas.
Incluye docstring.
```

Evita respuestas verbosas cuando solo quieres código.

### Patrón 4: Test-First Prompting

Pide tests primero, luego implementación.

```
Escribe tests para una función que valida números de tarjeta de crédito:
- Debe validar longitud (13-19 dígitos)
- Debe validar Luhn algorithm
- Debe identificar tipo de tarjeta (Visa, Mastercard, Amex)
- Debe rechazar tarjetas expiradas

Luego implementa la función que pase todos los tests.
```

Esto asegura que la implementación cubra todos los casos.

### Patrón 5: Critique-and-Improve

Pide a la IA que critique código existente.

```
Revisa este código como senior developer:

[tu código]

Identifica:
1. Bugs potenciales
2. Problemas de performance
3. Violaciones de best practices
4. Mejoras de legibilidad
5. Edge cases no manejados

Para cada issue, explica POR QUÉ es problema y CÓMO arreglarlo.
```

---

## Sección 3: Code Review Asistido por IA

### Usar IA Como Segundo Par de Ojos

**Flujo:**

1. **Escribes el código**
2. **Antes de PR, pides review a IA:**

```
Revisa este código antes de que lo suba a PR:

```python
[tu código]
```

Contexto del proyecto:
- Django REST API
- Standards: PEP 8, type hints obligatorios
- Security: user input siempre validado
- Tests: cobertura mínima 80%

Busca específicamente:
- SQL injection vulnerabilities
- N+1 query problems
- Missing error handling
- Type hint inconsistencies
- Edge cases sin tests
```

3. **IA responde con issues específicos**
4. **Corriges antes de human review**

**Beneficio:** Reduces round-trips en code review humano. Los reviewers se enfocan en lógica de negocio, no en syntax issues.

### Generar Test Cases

```
Para esta función:

```python
def calculate_shipping_cost(weight, origin, destination, service_level):
    # [implementación]
```

Genera test cases exhaustivos cubriendo:
- Happy path
- Boundary values (weight = 0, weight = max allowed)
- Invalid inputs (negative weight, unknown locations)
- Different service levels
- International vs domestic
- Edge cases (same origin and destination)

Formato: pytest
```

La IA genera 15-20 test cases que tal vez no pensaste.

---

## Sección 4: Learning Asistido por IA

### Aprender Frameworks Nuevos

**Estrategia clásica:**
1. Leer documentación completa (8 horas)
2. Seguir tutorial (4 horas)
3. Construir proyecto de prueba (12 horas)
Total: 24 horas

**Estrategia con IA:**
1. **Contexto + objetivo específico:**

```
Necesito aprender FastAPI para migrar una API existente de Flask.

Mi API actual tiene:
- Autenticación JWT
- Base de datos PostgreSQL (SQLAlchemy)
- Background tasks (Celery)
- File uploads
- WebSockets para real-time updates

Enséñame FastAPI mostrando:
1. Equivalentes FastAPI para cada concepto Flask que uso
2. Diferencias importantes en arquitectura
3. Migration path recomendado
4. Gotchas comunes viniendo de Flask

Dame ejemplos lado-a-lado: Flask vs FastAPI
```

**2. Learning by doing con IA como tutor:**

```
Voy a implementar feature X en FastAPI.
Corrígeme si me equivoco, sugiere mejores approaches.

[escribes código]

[IA corrige y explica]
```

Total: 8-10 horas (60% más rápido)

### Entender Codebase Legacy

```
Tengo este código legacy que no entiendo:

[código confuso]

Explícamelo:
1. ¿Qué hace en lenguaje simple?
2. ¿Por qué está estructurado así?
3. ¿Qué problemas intenta resolver?
4. ¿Qué refactorings recomendarías?
5. ¿Cómo lo reescribirías modernamente?
```

Mucho más rápido que reverse-engineer manualmente.

---

## Sección 5: Debugging con IA

### Patrón: Stack Trace Analysis

```
Tengo este error en producción:

```
[stack trace completo]
```

Contexto:
- Django 4.2, Python 3.11
- PostgreSQL 14
- Ocurre solo en production, no en local
- Empezó después de deploy de feature X
- Ocurre para ~5% de requests

Código relevante:
[código donde falla]

Analiza:
1. ¿Qué causa el error?
2. ¿Por qué solo en producción?
3. ¿Por qué solo 5% de requests? (race condition?)
4. ¿Cómo reproducirlo localmente?
5. ¿Cómo arreglarlo?
```

### Patrón: Behavioral Debugging

Cuando el código funciona pero comportamiento es incorrecto:

```
Este código DEBERÍA [comportamiento esperado],
pero está haciendo [comportamiento actual].

[código]

He verificado:
- Los inputs son correctos: [ejemplos]
- Las validaciones pasan
- No hay errores en logs

¿Dónde está el bug? Piensa paso a paso.
```

La IA hace "rubber duck debugging" estructurado.

---

## Sección 6: Quality Assurance con IA

### Security Review Automático

```
Revisa este código buscando vulnerabilidades de seguridad:

[código]

Específicamente busca:
- SQL injection
- XSS
- CSRF
- Authentication bypass
- Authorization issues
- Sensitive data exposure
- Insecure cryptography
- Race conditions

Para cada vulnerability encontrada:
1. Explica el riesgo
2. Muestra exploit example
3. Sugiere fix
```

### Performance Analysis

```
Este endpoint es lento (~800ms promedio). Analiza:

[código del endpoint]

Database schema:
[schema relevante]

Identifica:
- N+1 queries
- Missing indexes
- Inefficient algorithms
- Oportunidades de caching
- Optimizaciones de DB queries

Prioriza fixes por impacto esperado.
```

---

## Sección 7: Antipatrones de AI Usage

### Antipatrón 1: Blind Trust

**Problema:**
```python
# Pregunta: "Cómo hacer hash de password"
# IA responde:
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()

# Developer lo usa sin cuestionar
```

**Solución:** SIEMPRE cuestiona respuestas de seguridad/cryptografía. MD5 es inseguro.

### Antipatrón 2: Lazy Prompting

**Problema:**
```
"código para login"
```

Prompt vago → código genérico inútil

**Solución:** Invierte tiempo en prompt detallado. 5 minutos de prompt bueno ahorra 2 horas de iteración.

### Antipatrón 3: Context Overload

**Problema:**
```
[Pega 2000 líneas de código]

"Encuentra el bug"
```

Demasiado contexto → IA se pierde en ruido

**Solución:** Minimiza contexto. Solo código directamente relevante.

### Antipatrón 4: No Verificar Outputs

**Problema:** Copiar código de IA directo a producción sin tests.

**Solución:** Siempre escribe tests para código generado por IA.

---

## Sección 8: Workflows Completos con IA

### Workflow 1: Nueva Feature End-to-End

**Step 1: Diseño (con IA)**
```
Feature request: [descripción]

Como arquitecto, diseña:
1. Models de DB necesarios
2. API endpoints
3. Validaciones
4. Edge cases a considerar
5. Security considerations
```

**Step 2: Implementación (con Copilot)**
- Copilot genera boilerplate
- Tú ajustas lógica de negocio específica

**Step 3: Tests (con IA)**
```
Para esta implementación:
[código]

Genera test suite completa
```

**Step 4: Review (con IA)**
```
Revisa como senior:
[código + tests]
```

**Step 5: Documentación (con IA)**
```
Genera documentación API para:
[endpoints]

Formato: OpenAPI 3.0
Incluye ejemplos de requests/responses
```

**Tiempo total:** 60% menos que sin IA

### Workflow 2: Refactoring Legacy Code

**Step 1: Entendimiento**
```
Explica este código legacy:
[código]
```

**Step 2: Tests Primero**
```
Genera tests que capturen comportamiento actual:
[código]
```

**Step 3: Refactor Propuesto**
```
Refactoriza este código manteniendo comportamiento:
[código]

Objetivos:
- Reducir complejidad ciclomática
- Mejorar legibilidad
- Seguir principios SOLID
- Mantener compatibilidad con tests
```

**Step 4: Validación**
```
Compara comportamiento:
Old: [código original]
New: [código refactored]

¿Son funcionalmente equivalentes?
```

---

## Conclusión: IA como Multiplicador de Habilidad

Ricardo, del inicio, transformó completamente su productividad aprendiendo a trabajar efectivamente con IA.

**Antes:**
- Preguntaba vagamente
- Aceptaba respuestas sin verificar
- Usaba IA solo para snippets

**Después:**
- Prompts estructurados con CORE framework
- Siempre verifica con tests
- Usa IA en todo el workflow: diseño, implementación, testing, review, docs

**Resultado:**
- Velocidad de desarrollo: +47%
- Calidad (bugs/1000 LOC): -31%
- Aprendizaje de tecnologías nuevas: 2.5x más rápido
- Satisfacción: "Siento que tengo un senior developer siempre disponible"

La IA no es magia. Es una herramienta. Como cualquier herramienta, tu efectividad depende de tu habilidad usándola.

**Aprende a hacer las preguntas correctas. La IA tiene las respuestas.**

---

## Takeaways - IA Practices

**Esta semana:**
1. Usa framework CORE en tus próximos 5 prompts
2. Pide a IA que revise tu código antes de PR
3. Genera tests con IA para una feature
4. Compara tiempo/calidad vs método tradicional

**Este mes:**
1. Desarrolla biblioteca personal de prompts efectivos
2. Integra IA en tu workflow completo
3. Usa IA para aprender una tecnología nueva
4. Mide mejora en productividad

**Este trimestre:**
1. Conviértete en experto de prompting
2. Enseña best practices a tu equipo
3. Crea templates de prompts para tu proyecto
4. Documenta casos de uso donde IA es más efectiva

---

## Referencias

White, J., et al. (2023). "A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT." *arXiv preprint arXiv:2302.11382*.

Zamfirescu-Pereira, J. D., et al. (2023). "Why Johnny Can't Prompt: How Non-AI Experts Try (and Fail) to Design LLM Prompts." *CHI 2023*.

OpenAI. (2023). "GPT-4 Technical Report." *arXiv preprint arXiv:2303.08774*.

---

**Palabras: 4,022**
