require 'rspec'
require_relative '../src/tadspec'

class Persona
  def initialize(edad)
    @edad = edad
  end

  def viejo?
    @edad > 29
  end

  def envejecer(anios)
    @edad += anios
  end
end

describe 'TADSpec' do

  before do
    class << self
      include Matchers
    end
  end

  describe 'Assertions' do

    it 'puede assertear que 2 + 2 es mayor que 3' do
      (2 + 2).deberia ser mayor_a 3
    end

    it 'falla el assert que 2 + 2 es mayor que 10' do
      expect { (2 + 2).deberia ser mayor_a 10 }.to raise_error TADSpecAssertionError
    end

    it 'puede assertear objetos con mensajes booleanos' do
      Persona.new(30).deberia ser_viejo
      expect { Persona.new(28).deberia ser_viejo }.to raise_error TADSpecAssertionError
    end

    it 'puede assertear objetos con mensajes booleanos' do
      Persona.new(30).deberia tener_edad mayor_a 28
      expect { Persona.new(30).deberia tener_edad mayor_a 50 }.to raise_error TADSpecAssertionError
    end

  end

  describe 'Suite' do
    class SuiteOk
      # Esto es un test
      def testear_que_las_personas_de_30_son_viejas
        Persona.new(30).deberia ser_viejo
      end

      # Esto no
      def las_personas_de_30_son_viejas
        Persona.new(30).deberia ser_viejo
      end
    end

    class SuiteError
      def testear_que_las_personas_de_20_son_viejas
        Persona.new(20).deberia ser_viejo
      end
    end

    it 'puede evaluar una suite sin errores' do
      TADSpec.testear SuiteOk
    end

    it 'puede evaluar una suite con errores' do
      expect { TADSpec.testear SuiteError }.to raise_error TADSpecAssertionError
    end
  end

  describe 'Mocks' do

    class PersonaHome
      def todas_las_personas
        # Este método consume un servicio web que consulta una base de datos
      end

      def personas_viejas
        self.todas_las_personas.select { |p| p.viejo? }
      end
    end

    it 'testear_que_personas_viejas_trae_solo_a_los_viejos' do
      nico = Persona.new(30)
      axel = Persona.new(30)
      lean = Persona.new(22)

      # Mockeo el mensaje para no consumir el servicio y simplificar el test
      home = PersonaHome.new.mockear(:todas_las_personas) do
        [nico, axel, lean]
      end

      expect(home.personas_viejas).to eq [nico, axel]
    end

  end

  describe 'Spy' do

    it 'puede validar que se manda un mensaje' do
      pato = espiar(Persona.new(23))
      pato.viejo?

      pato.deberia haber_recibido(:viejo?)
      expect { pato.deberia haber_recibido(:zarlompa) }.to raise_error TADSpecAssertionError
    end

    it 'puede validar que se manda un mensaje con argumentos' do
      pato = espiar(Persona.new(23))
      pato.viejo?
      pato.envejecer(10)

      pato.deberia haber_recibido(:viejo?).con_argumentos()
      expect { pato.deberia haber_recibido(:viejo?).con_argumentos(19, "hola") }.to raise_error TADSpecAssertionError

      pato.deberia haber_recibido(:envejecer)
      pato.deberia haber_recibido(:envejecer).con_argumentos(10)
      expect { pato.deberia haber_recibido(:envejecer).con_argumentos(20) }.to raise_error TADSpecAssertionError
    end

  end
end
