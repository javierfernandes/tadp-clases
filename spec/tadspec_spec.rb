require 'rspec'
require_relative '../src/tadspec'

describe 'TP' do

  before do
    include TADsPEC
  end

  context 'aserciones' do

    it 'deberia assertear que 2 + 2 es igual a 4' do
      expect(TADTest.evalua { (2 + 2).deberia ser 4 }).to be(true)
    end

    it 'deberia assertear que 2 + 2 es mayor que 3' do
      expect(TADTest.evalua { (2 + 2).deberia ser mayor_a 3 }).to be(true)
    end

    context 'Con una clase con metodos de consulta booleana' do
      class Persona
        def initialize(edad)
          @edad = edad
        end
        def viejo?
          @edad > 30
        end
      end

      it 'deberia assertear que una instancia de esa clase cumple la consulta' do
        resultado = TADTest.evalua do
          nico = Persona.new(31)
          nico.deberia ser_viejo
        end

        expect(resultado).to be true
      end

      it 'deberia romper si la instancia no conoce el metodo de consulta' do
        (expect do
          TADTest.evalua do
            nico = Persona.new(30)
            nico.deberia ser_pelado
          end
        end).to raise_error NoMethodError
      end
    end

    context 'con objetos que tienen atributos' do
      class Pepita
        def initialize
          @energia = 20
        end
      end
      it 'deberia assertear que un objeto tiene un atributo con determinado valor' do
        expect(TADTest.evalua { Pepita.new.deberia tener_energia 20 }).to be true
      end

      it 'deberia assertear que un objeto tiene un atributo que cumple una cierta asercion' do
        expect(TADTest.evalua { Pepita.new.deberia tener_energia mayor_a 3 }).to be true
      end
    end


    describe 'Mocks' do
      class Guerrero
        attr_reader :salud
        def initialize
          @salud = 100
        end
        def sufrir_danio
          @salud -= 30
        end
      end

      it 'una instancia de una clase a la que le mockeamos un mensaje responde el resultado mockeado en vez de su verdadera implementacion' do
        resultadoDePrimerTest = TADTest.evalua do
          Guerrero.mockear(:salud) { 42 }

          atila = Guerrero.new

          atila.salud.deberia ser 42
        end

        resultadoDelSegundoTest = TADTest.evalua do
          atila = Guerrero.new

          atila.salud.deberia ser 100
        end

        expect(resultadoDePrimerTest).to be true
        expect(resultadoDelSegundoTest).to be true
      end
    end
  end
end
