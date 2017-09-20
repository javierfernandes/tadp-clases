Clase 6 TADP 2C2017

## Assertions

#### ser [matcher]
```ruby
leandro.edad.deberia ser mayor_a 20
```

#### ser_[condicion]
```ruby
class Persona
  def viejo?
    @edad > 29
  end
end

nico.deberia ser_viejo    # pasa: Nico tiene edad 30.
```

#### tener_[atributo] [matcher]
```ruby
objeto.deberia tener_[nombre del atributo] valor_esperado

leandro.deberia tener_edad mayor_a 22 # pasa
leandro.deberia tener_altura mayor_a 123 # falla: no hay atributo altura
```

## Suites y Tests

```ruby
class MiSuite
  # Esto es un test
  def testear_que_las_personas_de_mas_de_29_son_viejas
    persona = Persona.new(30)
    persona.deberia ser_viejo
  end
  
  # Esto no
  def las_personas_de_mas_de_29_son_viejas
    persona = Persona.new(30)
    persona.deberia ser_viejo
  end
end

TADsPec.testear MiSuite
```

## Mocking & Spying

## Ejercicio Integrador
El siguiente ejercicio fue el TP de metaprogramación del 2do cuatrimestre de 2016. Incluye también lo que luego fueron TPs individuales.
Enunciado: https://docs.google.com/document/d/1bP12p1qKRNoGORs3bb1At7qeU4iAk0CHbtYODIN-QLI/edit

Acá está como se resolvió en el otro aula: https://github.com/tadp-utn-frba/tadp-clases/tree/ruby-tadspec
