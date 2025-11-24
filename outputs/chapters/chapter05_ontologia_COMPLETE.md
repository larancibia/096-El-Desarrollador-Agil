# Capítulo 5: Ontología del Software

## El Diseño que Nadie Entendía

Diana era arquitecta de software senior en una fintech. Durante tres meses, había diseñado meticulosamente un sistema de procesamiento de transacciones. El diagrama de arquitectura era una obra de arte: microservicios elegantemente desacoplados, event sourcing para audit trail, CQRS para separación de lectura/escritura, Redis para cache, Kafka para messaging. Tecnicamente impecable.

Cuando presentó el diseño al equipo, esperaba aplausos. En cambio, obtuvo silencio incómodo.

"Diana," dijo finalmente Miguel, developer mid-level, "no entiendo qué es un TransactionAggregate vs un TransactionEntity vs un TransactionEvent. ¿No son todos... transacciones?"

Diana sintió frustración. ¿Cómo era posible que no vieran las distinciones obvias? Un Aggregate es una unidad de consistencia, un Entity tiene identidad persistente, un Event es un hecho inmutable del pasado. Conceptos básicos de DDD.

Pero cuando pidió a otros developers que explicaran la diferencia, nadie pudo. Cuando revisó el código tres sprints después, encontró:

- `TransactionAggregate` siendo usado como simple data transfer object
- `TransactionEntity` duplicando lógica que debería estar en el Aggregate
- `TransactionEvent` con campos mutables (contradiciendo su naturaleza de evento)
- Un nuevo `TransactionHandler`, `TransactionProcessor` y `TransactionManager` que nadie le había consultado, haciendo cosas que se superponían sin claridad de responsabilidad

El sistema técnicamente funcionaba. Pero conceptualmente era caótico. Cada developer tenía su propio modelo mental de qué significaba cada pieza, resultando en inconsistencias, bugs sutiles y confusión crónica.

Diana no había fallado técnicamente. Había fallado **ontológicamente**.

---

## Sección 1: ¿Qué Es Ontología y Por Qué Importa?

### La Pregunta Fundamental: ¿Qué Existe?

La ontología es una rama de la filosofía que estudia la naturaleza de la existencia. Se pregunta: ¿Qué tipos de cosas existen? ¿Cómo se relacionan entre sí? ¿Qué categorías fundamentales usamos para organizar el mundo?

Suena abstracto. Pero es profundamente relevante para software.

Porque cuando diseñas un sistema de software, estás creando un universo. Un universo poblado por entidades—usuarios, transacciones, productos, pedidos, pagos. Y la pregunta ontológica que defines (consciente o inconscientemente) es:

**¿Qué tipos de cosas existen en mi sistema? ¿Cómo se relacionan? ¿Qué categorías fundamentales organizan mi dominio?**

Si tu respuesta es confusa, vaga o inconsistente, tu código será confuso, vago e inconsistente. No importa cuán elegante sea tu infraestructura técnica.

### Ontología vs Implementación

Hay una distinción crítica que muchos developers confunden:

**Ontología:** ¿Qué es esta cosa conceptualmente? ¿Qué significa?
**Implementación:** ¿Cómo se representa técnicamente en código?

Ejemplo:

```python
# Implementación 1: User como diccionario
user = {"id": 123, "email": "ana@example.com", "role": "admin"}

# Implementación 2: User como clase
class User:
    def __init__(self, id, email, role):
        self.id = id
        self.email = email
        self.role = role

# Implementación 3: User como tabla de base de datos
CREATE TABLE users (id INT, email VARCHAR, role VARCHAR);
```

Tres implementaciones diferentes. Pero **ontológicamente**, todas representan la misma entidad: un User.

La confusión de Diana surgió porque mezclaba implementaciones técnicas (Aggregates, Entities, Events—patrones de DDD) con conceptos de dominio (Transaction). Su equipo no tenía claridad sobre **qué significaba** un Transaction en el contexto del negocio.

### El Problema del Naming: Palabras Sin Significado

El síntoma más común de confusión ontológica es naming inconsistente:

```python
class TransactionManager:
    def process_transaction(self, transaction):
        handler = TransactionHandler()
        processor = TransactionProcessor()
        # ¿Cuál es la diferencia entre process, handle y... process?
```

Manager, Handler, Processor, Service, Helper, Utility—**palabras genéricas que no comunican ontología**. Son como decir "cosa" en lugar de "perro" o "árbol".

Compare con:

```python
class PaymentGateway:  # Claramente una puerta de entrada a sistema de pagos
    def authorize(self, payment):  # Acción específica: autorizar
        ...

class PaymentValidator:  # Claramente valida pagos
    def validate(self, payment):
        ...

class PaymentLedger:  # Claramente un libro de registro
    def record(self, payment):
        ...
```

Cada nombre comunica **qué es** la cosa y **por qué existe**. No hay ambigüedad ontológica.

---

## Sección 2: Categorías Fundamentales en Sistemas de Software

Para construir sistemas ontológicamente coherentes, necesitas entender las categorías fundamentales que organizan el software.

### Categoría 1: Entidades (Entities)

**Definición ontológica:** Una cosa que tiene identidad persistente a través del tiempo, incluso si sus propiedades cambian.

**Criterio de identificación:** Si dos instancias tienen el mismo ID, son la misma entidad, incluso si sus otros atributos difieren.

**Ejemplo:**

```python
# Un User es una entidad
user_t0 = User(id=42, email="ana@old.com", status="inactive")
user_t1 = User(id=42, email="ana@new.com", status="active")

# A pesar de que email y status cambiaron,
# ambos representan al MISMO user (id=42)
assert user_t0.id == user_t1.id  # Misma identidad
```

**Preguntas para identificar entidades:**
- ¿Tiene un ciclo de vida (creación, modificación, eliminación)?
- ¿Importa distinguir esta instancia específica de otras similares?
- ¿Necesitas trackear cambios a lo largo del tiempo?

Si respondiste sí, probablemente es una entidad.

**Ejemplos en diferentes dominios:**
- E-commerce: User, Order, Product, Payment
- Banking: Account, Transaction, Customer, Card
- Healthcare: Patient, Appointment, Prescription, Doctor

### Categoría 2: Valores (Value Objects)

**Definición ontológica:** Una cosa definida completamente por sus atributos. No tiene identidad independiente.

**Criterio de identificación:** Si dos instancias tienen los mismos atributos, son intercambiables e indistinguibles.

**Ejemplo:**

```python
# Money es un value object
price1 = Money(amount=100, currency="USD")
price2 = Money(amount=100, currency="USD")

# Son completamente intercambiables
assert price1 == price2  # Igualdad por valor, no por identidad

# No tiene sentido preguntar "cuál de los dos"
# porque son conceptualmente el mismo
```

**Preguntas para identificar value objects:**
- ¿Solo importan sus atributos, no su identidad?
- ¿Puedes reemplazarlo por otro con mismos valores sin consecuencias?
- ¿Es inmutable conceptualmente?

Si respondiste sí, probablemente es un value object.

**Ejemplos:**
- Money (cantidad + moneda)
- DateRange (inicio + fin)
- Address (calle, ciudad, país, código postal)
- Email (string validado)
- Coordinate (lat + long)

**Por qué importa la distinción:**

```python
# ❌ Modelar Money como entidad es error ontológico
class Money:
    def __init__(self, id, amount, currency):
        self.id = id  # ¿Por qué Money tendría identidad?
        self.amount = amount
        self.currency = currency

# ✅ Modelar como value object
class Money:
    def __init__(self, amount, currency):
        self.amount = amount
        self.currency = currency
        # Inmutable - no hay setters
```

Si modelas Money con identity, tu código asumirá que dos instancias de $100 USD podrían ser diferentes. Esto llevará a bugs sutiles y confusión.

### Categoría 3: Agregados (Aggregates)

**Definición ontológica:** Un cluster de entidades y value objects tratados como una unidad conceptual, con una entidad raíz que actúa como puerta de entrada.

**Criterio de identificación:** Define una frontera de consistencia—operaciones que deben ser atómicamente consistentes se agrupan en un aggregate.

**Ejemplo:**

```python
# Order es un aggregate root
class Order:
    def __init__(self, id):
        self.id = id
        self.items = []  # OrderItems son parte del aggregate
        self.status = "pending"
        self.total = Money(0, "USD")

    def add_item(self, product, quantity):
        # Regla de negocio: no puedes modificar orden shipped
        if self.status == "shipped":
            raise Exception("Cannot modify shipped order")

        item = OrderItem(product, quantity)
        self.items.append(item)
        self._recalculate_total()

    def _recalculate_total(self):
        # Invariant: total debe ser suma de items
        self.total = sum(item.price for item in self.items)

# OrderItem NO es un aggregate - es parte del Order aggregate
class OrderItem:
    def __init__(self, product, quantity):
        self.product = product
        self.quantity = quantity
        self.price = product.price * quantity
```

**Por qué Order es aggregate:**
- Agrupa Order + OrderItems como unidad conceptual
- Impone invariantes (no modificar si shipped)
- OrderItems no tienen sentido fuera de un Order
- Accedes a OrderItems SOLO a través de Order

**Preguntas para identificar aggregates:**
- ¿Hay un grupo de objetos que deben ser consistentes entre sí?
- ¿Hay una entidad "principal" que controla acceso a las demás?
- ¿Hay reglas de negocio que abarcan múltiples objetos relacionados?

### Categoría 4: Eventos (Events)

**Definición ontológica:** Un hecho del pasado que ocurrió en un momento específico y no puede cambiar.

**Criterio de identificación:** Es inmutable, tiene timestamp, describe algo que YA sucedió (pasado).

**Ejemplo:**

```python
# Event - describe algo que YA pasó
class OrderPlaced:
    def __init__(self, order_id, user_id, items, timestamp):
        self.order_id = order_id
        self.user_id = user_id
        self.items = items
        self.timestamp = timestamp
        # Inmutable - frozen en el pasado

    # ❌ No hay setters - eventos no cambian
    # ✅ Solo getters
```

**Contraste con comandos y entidades:**

```python
# Comando - intención de hacer algo (futuro/imperativo)
class PlaceOrder:
    def __init__(self, user_id, items):
        self.user_id = user_id
        self.items = items

# Evento - hecho de que algo sucedió (pasado)
class OrderPlaced:
    def __init__(self, order_id, user_id, items, timestamp):
        self.order_id = order_id
        self.user_id = user_id
        self.items = items
        self.timestamp = timestamp

# Entidad - estado actual
class Order:
    def __init__(self, id, status):
        self.id = id
        self.status = status  # Mutable - cambia con el tiempo
```

**Naming convention:**
- Comandos: imperativo—PlaceOrder, CancelOrder, AddItem
- Eventos: pasado—OrderPlaced, OrderCancelled, ItemAdded
- Entidades: sustantivo—Order, User, Payment

El naming comunica ontología.

### Categoría 5: Servicios (Services)

**Definición ontológica:** Una operación o proceso que no pertenece naturalmente a ninguna entidad específica.

**Criterio de identificación:** Si una operación involucra múltiples entidades o no tiene estado propio, probablemente es un servicio.

**Ejemplo:**

```python
# ¿Este método pertenece a Order o a PaymentGateway?
# Respuesta: A ninguno - es una operación entre dos dominios
class PaymentService:
    def __init__(self, payment_gateway, order_repository):
        self.gateway = payment_gateway
        self.repository = order_repository

    def charge_for_order(self, order, payment_method):
        # Coordina entre Order y Payment domains
        amount = order.total
        payment = self.gateway.charge(payment_method, amount)
        order.mark_as_paid(payment.id)
        self.repository.save(order)
        return payment
```

**Cuándo usar servicios:**
- Operación coordina múltiples aggregates
- Lógica no encaja naturalmente en ninguna entidad
- Integración con sistemas externos
- Procesos complejos de negocio que atraviesan boundaries

**Advertencia:** No uses Service como catch-all para toda lógica. Primero pregunta: "¿Pertenece esta lógica a una entidad?" Solo si la respuesta es claramente no, crea un service.

---

## Sección 3: Domain-Driven Design Como Ontología Aplicada

Domain-Driven Design (DDD), popularizado por Eric Evans en 2003, es fundamentalmente una práctica ontológica aplicada a software.

### El Lenguaje Ubicuo (Ubiquitous Language)

La idea central de DDD: **developers y domain experts deben usar exactamente el mismo lenguaje para hablar del dominio**.

**Sin lenguaje ubicuo:**

```
Domain Expert: "Cuando el cliente completa el checkout..."
Developer: "Oh, cuando se triggerea el PurchaseCompletionHandler..."
Domain Expert: "...y el payment es exitoso..."
Developer: "Sí, cuando el TransactionProcessor recibe PaymentSuccessEvent..."
```

Son dos idiomas diferentes. El developer traduce mentalmente entre el lenguaje del negocio y el código. Cada traducción es oportunidad de malentendido.

**Con lenguaje ubicuo:**

```
Domain Expert: "Cuando el cliente completa el Checkout..."
Developer: "Sí, cuando ejecutamos Checkout.complete()..."
Domain Expert: "...y el Payment es exitoso..."
Developer: "Correcto, cuando Payment alcanza estado Completed..."
```

El código usa LOS MISMOS TÉRMINOS que el negocio. No hay traducción. La ontología del código refleja la ontología del dominio.

**Implementación:**

```python
# ❌ Sin lenguaje ubicuo
class PurchaseCompletionHandler:
    def handle(self, transaction_data):
        processor = TransactionProcessor()
        result = processor.process(transaction_data)
        if result.status == "ok":
            EmailService.send_confirmation(transaction_data.user_email)

# ✅ Con lenguaje ubicuo
class Checkout:
    def complete(self, payment):
        if payment.is_successful():
            self.status = CheckoutStatus.COMPLETED
            self.confirm_to_customer()

    def confirm_to_customer(self):
        ConfirmationEmail(self.customer.email).send()
```

Lee el código con lenguaje ubicuo en voz alta. Suena como conversación de negocio, no como jerga técnica.

### Bounded Contexts: Ontologías Múltiples

Aquí está un insight profundo: **la misma palabra puede significar cosas diferentes en contextos diferentes**.

Ejemplo: "Customer" en una empresa de software.

**En Sales context:**
- Customer = empresa que compró licencia
- Atributos: contract value, renewal date, account manager
- Comportamientos: upgrade plan, renew contract

**En Support context:**
- Customer = persona que reporta un problema
- Atributos: tickets abiertos, satisfaction score, last contact
- Comportamientos: open ticket, rate support interaction

**En Product context:**
- Customer = usuario que usa el software
- Atributos: features usadas, usage metrics, segment
- Comportamientos: use feature, provide feedback

Tres ontologías diferentes para "Customer". Si intentas crear UN solo modelo de Customer que satisfaga los tres contextos, obtendrás:

```python
# ❌ God Class - intenta ser todo para todos
class Customer:
    # Sales attributes
    contract_value = ...
    renewal_date = ...
    account_manager = ...

    # Support attributes
    tickets = ...
    satisfaction_score = ...

    # Product attributes
    usage_metrics = ...
    features_used = ...

    # Demasiadas responsabilidades, confusión ontológica
```

**La solución: Bounded Contexts**

Cada contexto tiene su PROPIA definición de Customer:

```python
# Sales context
class SalesCustomer:
    contract_value = ...
    renewal_date = ...

# Support context
class SupportTicketRequester:  # Diferente nombre!
    tickets = ...
    satisfaction_score = ...

# Product context
class ProductUser:  # Diferente nombre!
    usage_metrics = ...
    features_used = ...
```

Tres modelos distintos, cada uno ontológicamente coherente dentro de su contexto.

**Mapeo entre contextos:**

Cuando Sales necesita información de Support:

```python
# Translation layer entre contextos
class CustomerContextMapper:
    def to_support_view(self, sales_customer):
        return SupportTicketRequester.find_by_email(sales_customer.email)
```

Explícitamente traduces entre ontologías. No pretendes que son la misma cosa.

### Agregados Definen Boundaries Transaccionales

En DDD, aggregates no son solo agrupación lógica—definen **boundaries de consistencia transaccional**.

**Regla de oro:** Una transacción de base de datos debe modificar MÁXIMO un aggregate.

**Por qué:**

```python
# ❌ Transacción modificando múltiples aggregates
def transfer_funds(from_account, to_account, amount):
    # Dos aggregates en una transacción
    from_account.withdraw(amount)
    to_account.deposit(amount)
    db.commit()  # Ambos o ninguno

# Problema: No escala. ¿Qué si accounts están en DBs diferentes?
# ¿En regiones diferentes? ¿En microservicios diferentes?
```

**Alternativa ontológica:**

```python
# ✅ MoneyTransfer como su propio aggregate
class MoneyTransfer:
    def __init__(self, from_account_id, to_account_id, amount):
        self.from_account_id = from_account_id
        self.to_account_id = to_account_id
        self.amount = amount
        self.status = TransferStatus.PENDING

    def execute(self):
        # 1. Registrar intención
        self.status = TransferStatus.IN_PROGRESS
        db.commit()

        # 2. Withdraw (separate transaction)
        account_service.withdraw(self.from_account_id, self.amount)

        # 3. Deposit (separate transaction)
        account_service.deposit(self.to_account_id, self.amount)

        # 4. Completar
        self.status = TransferStatus.COMPLETED
        db.commit()
```

Ahora MoneyTransfer es un aggregate que coordina operaciones en otros aggregates. Cada operación es transacción separada. Si algo falla, tienes audit trail y puedes compensar.

Esto es ontología influyendo en arquitectura técnica.

---

## Sección 4: Antipatrones Ontológicos

### Antipatrón 1: Anemic Domain Model

**Síntoma:** Tus "entidades" son solo data bags sin comportamiento.

```python
# ❌ Anemic model
class Order:
    def __init__(self):
        self.items = []
        self.status = "pending"
        self.total = 0

# Toda la lógica está en "services"
class OrderService:
    def add_item(self, order, product, quantity):
        item = OrderItem(product, quantity)
        order.items.append(item)
        order.total += item.price

    def ship(self, order):
        if order.status != "pending":
            raise Exception("Invalid status")
        order.status = "shipped"
```

**Problema ontológico:** Separaste el comportamiento de la identidad. Order es tratado como simple estructura de datos, no como entidad con comportamiento propio.

**Solución:**

```python
# ✅ Rich domain model
class Order:
    def __init__(self):
        self.items = []
        self.status = OrderStatus.PENDING
        self.total = Money(0, "USD")

    def add_item(self, product, quantity):
        if self.status != OrderStatus.PENDING:
            raise InvalidOperationError("Cannot modify non-pending order")

        item = OrderItem(product, quantity)
        self.items.append(item)
        self._recalculate_total()

    def ship(self):
        if self.status != OrderStatus.PENDING:
            raise InvalidStatusTransition()

        self.status = OrderStatus.SHIPPED
```

La entidad contiene su comportamiento. Esto es coherencia ontológica.

### Antipatrón 2: God Class

**Síntoma:** Una clase que hace todo.

```python
# ❌ God class
class UserManager:
    def create_user(self, email, password): ...
    def authenticate(self, email, password): ...
    def update_profile(self, user_id, data): ...
    def send_email(self, user_id, subject, body): ...
    def charge_subscription(self, user_id, amount): ...
    def generate_reports(self): ...
    # 50 more methods...
```

**Problema ontológico:** UserManager no tiene coherencia ontológica. No representa UN concepto del dominio—es un catch-all.

**Solución:** Descomponer según responsabilidades ontológicas claras.

```python
# ✅ Ontológicamente coherente
class User:  # Entidad
    def update_profile(self, data): ...

class UserAuthenticator:  # Servicio de autenticación
    def authenticate(self, email, password): ...

class UserRepository:  # Servicio de persistencia
    def save(self, user): ...
    def find_by_email(self, email): ...

class UserNotifier:  # Servicio de notificaciones
    def send_email(self, user, subject, body): ...

class SubscriptionBiller:  # Servicio de billing
    def charge(self, user, amount): ...
```

Cada clase tiene un significado ontológico claro.

### Antipatrón 3: Primitive Obsession

**Síntoma:** Usar primitives (strings, integers) donde deberías usar value objects.

```python
# ❌ Primitive obsession
class User:
    def __init__(self, email, password):
        self.email = email  # Simple string
        self.password = password  # Simple string

# Problemas:
user = User("not-an-email", "123")  # No validation
user.email = "definitely not email"  # Can mutate to invalid state
```

**Problema ontológico:** Email no es ontológicamente "solo un string". Es un concepto con reglas específicas.

**Solución:**

```python
# ✅ Value objects para conceptos de dominio
class Email:
    def __init__(self, value):
        if not self._is_valid(value):
            raise InvalidEmailError(value)
        self._value = value

    @staticmethod
    def _is_valid(value):
        return "@" in value and "." in value  # Simplified

    def __str__(self):
        return self._value

    def __eq__(self, other):
        return isinstance(other, Email) and self._value == other._value

class Password:
    def __init__(self, plaintext):
        if len(plaintext) < 8:
            raise WeakPasswordError()
        self._hash = self._hash_password(plaintext)

    @staticmethod
    def _hash_password(plaintext):
        return hashlib.sha256(plaintext.encode()).hexdigest()

    def verify(self, plaintext):
        return self._hash == self._hash_password(plaintext)

# Uso
class User:
    def __init__(self, email, password):
        self.email = Email(email)  # Validated automatically
        self.password = Password(password)  # Hashed automatically
```

Email y Password son value objects con comportamiento propio. Imposible crear instancia inválida.

---

## Sección 5: Descubriendo Tu Ontología

### Event Storming: Mapeando el Dominio

Event Storming es una técnica colaborativa para descubrir ontología del dominio. Creada por Alberto Brandolini.

**Proceso:**

1. **Reunir stakeholders:** Developers + domain experts
2. **Pared grande + sticky notes:** Necesitas espacio
3. **Identificar domain events** (color naranja): Cosas que suceden
   - OrderPlaced, PaymentProcessed, UserRegistered

4. **Identificar comandos** (color azul): Acciones que causan eventos
   - PlaceOrder → OrderPlaced
   - ProcessPayment → PaymentProcessed

5. **Identificar aggregates** (color amarillo): Entidades que manejan comandos
   - Order aggregate maneja PlaceOrder command

6. **Identificar bounded contexts:** Áreas con su propia ontología
   - Sales context, Fulfillment context, Billing context

7. **Mapear flujos:** Cómo eventos disparan otros comandos
   - OrderPlaced → comando TriggerPayment → PaymentProcessed

**Output:** Un mapa visual de tu dominio que muestra ontología completa.

**Beneficios:**
- Descubres ambigüedades ontológicas temprano
- Todos—developers y business—ven el mismo modelo
- Identificas bounded contexts naturalmente

### Técnica del "Glosario Viviente"

Mantén un glosario de términos del dominio que evoluciona con tu código.

**Formato:**

```markdown
# Glosario del Dominio - E-commerce

## Order (Entidad / Aggregate Root)
**Definición:** Solicitud de compra de un Customer, conteniendo uno o más OrderItems.
**Ciclo de vida:** Created → Confirmed → Paid → Shipped → Delivered → [Cancelled]
**Invariantes:**
- Total debe ser suma de items
- No se puede modificar si status es Shipped o Delivered
**Bounded Context:** Order Management

## Payment (Entidad)
**Definición:** Registro de transacción financiera asociada a un Order.
**Estados:** Pending → Processing → Completed / Failed
**Bounded Context:** Payment Processing

## Customer (Entidad - múltiples definiciones)
**En Sales Context:** Empresa que compró licencia
**En Support Context:** Persona que abre tickets
**En Product Context:** Usuario del software
```

**Reglas:**
1. Actualizar glosario ANTES de código cuando ontología cambia
2. Code reviews verifican que código coincide con glosario
3. Onboarding de nuevos developers empieza con glosario

---

## Sección 6: Ontología y APIs

Tu API comunica ontología a developers externos. Diseña ontológicamente.

### RESTful Design Como Ontología

REST es fundamentalmente ontológico: defines **recursos** (entidades en tu dominio) y **operaciones** sobre ellos.

**Diseño ontológicamente confuso:**

```
POST /process_order
POST /handle_payment
GET /get_user_data
POST /do_checkout
```

Verbos en URLs. Ontológicamente confuso: ¿Qué son estas cosas?

**Diseño ontológicamente claro:**

```
# Recursos (sustantivos) = Entidades
POST /orders              # Crear Order
GET /orders/{id}          # Obtener Order
PUT /orders/{id}          # Actualizar Order

# Sub-recursos
POST /orders/{id}/items   # Agregar OrderItem
POST /orders/{id}/shipment  # Triggear envío

# Relaciones entre recursos
GET /customers/{id}/orders  # Orders de un Customer
```

Cada URL representa una entidad o relación ontológica clara.

### GraphQL Schema Como Ontología

GraphQL force explicitness ontológica en tu schema:

```graphql
# Entidades
type Order {
  id: ID!
  status: OrderStatus!  # Enum = value object
  items: [OrderItem!]!  # Relación uno-a-muchos
  customer: Customer!   # Relación a otra entidad
  total: Money!         # Value object
}

type OrderItem {
  product: Product!
  quantity: Int!
  price: Money!
}

# Value Object
type Money {
  amount: Float!
  currency: String!
}

# Enum define posibles estados
enum OrderStatus {
  PENDING
  CONFIRMED
  SHIPPED
  DELIVERED
  CANCELLED
}
```

Tu schema ES tu ontología. Si está claro, tu API será fácil de entender.

---

## Conclusión: El Rediseño de Diana

Diana aprendió su lección. Tres meses después, lideró un nuevo proyecto: sistema de notificaciones.

Esta vez, empezó diferente. Antes de escribir una línea de código, hizo Event Storming con su equipo. Identificaron:

**Entidades claras:**
- Notification (el mensaje a enviar)
- Recipient (quien lo recibe)
- Channel (email, SMS, push)

**Value objects:**
- NotificationContent (mensaje + asunto)
- DeliverySchedule (cuándo enviar)

**Events:**
- NotificationScheduled
- NotificationSent
- DeliveryFailed

**Bounded contexts:**
- Notification Composition (crear contenido)
- Delivery Management (enviar)
- Analytics (métricas)

Crearon glosario. Definieron lenguaje ubicuo. Y solo entonces empezaron a codear.

El resultado: cuando nuevos developers se unieron tres meses después, entendieron el sistema en días, no semanas. El código prácticamente se autodocumentaba porque cada clase tenía significado ontológico claro.

Las retrospectivas mostraban comentarios como:
- "Este es el codebase más fácil de entender en el que he trabajado"
- "El naming es tan claro que raramente necesito preguntar qué hace algo"
- "Siento que el código habla el lenguaje del negocio"

Diana no había cambiado su habilidad técnica. Había cambiado su enfoque: de "¿cómo implemento esto técnicamente?" a "¿qué significa esto ontológicamente?"

**La arquitectura técnica fluye naturalmente de la claridad ontológica. Pero la claridad ontológica debe venir primero.**

---

## Takeaways - Ontología en Práctica

**Esta semana:**
1. Identifica una clase confusa en tu codebase
2. Pregunta: "¿Qué ES esto realmente?"
3. Renombra para reflejar ontología clara
4. Discute con tu equipo si están de acuerdo

**Este mes:**
1. Crea glosario de dominio para tu proyecto
2. Haz event storming session con tu equipo
3. Identifica un God Class y descomponlo ontológicamente
4. Refactoriza un anemic model a rich domain model

**Este trimestre:**
1. Establece lenguaje ubicuo para tu sistema
2. Identifica y documenta bounded contexts
3. Asegura que nuevos features respeten ontología
4. Mide: ¿Los nuevos developers entienden el sistema más rápido?

---

## Referencias

Evans, E. (2003). *Domain-Driven Design: Tackling Complexity in the Heart of Software*. Addison-Wesley.

Vernon, V. (2013). *Implementing Domain-Driven Design*. Addison-Wesley.

Brandolini, A. (2013). *Introducing Event Storming*. Leanpub.

Fowler, M. (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley.

Guarino, N. (1998). "Formal ontology and information systems." *Proceedings of FOIS*, 98(1), 3-15.

---

**Palabras: 4,267**
