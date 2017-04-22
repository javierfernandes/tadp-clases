require 'rspec'
require_relative '../src/tadspec'

describe 'Pruebas sobre tadspec' do

  it 'test fallido deberia ser' do
    test = UnTest.new
    expect(test.assertDeberiaSerFallido).to be(false)
  end
  it 'test correcto deberia ser' do
    test = UnTest.new
    expect(test.assertDeberiaSerCorrecto).to be(true)
  end
  it 'test deberia ser mayor' do
    test = UnTest.new
    expect(test.assertMayor).to be(true)
  end

  it 'mockeo' do
    test = PersonaHomeTests.new
    expect(test.testear_viejos).to be(true)
  end
end


class UnTest
  include TestSuite
  def assertDeberiaSerFallido
    7.deberia ser 8
  end
  def assertDeberiaSerCorrecto
    7.deberia ser 7
  end
  def assertMayor
    7.deberia ser mayor_a 6
  end
end

class Persona
  attr_accessor :edad
  def initialize(edad)
    self.edad = edad
  end
  def viejo?
    edad > 29
  end
end
class PersonaHome
  def self.todas_las_personas
    puts 'definicion posta'
    []
  end
  def self.personas_viejas
    self.todas_las_personas.select {|p| p.viejo?}
  end
end
class PersonaHomeTests
  include TestSuite
  def testear_viejos
    nico = Persona.new(30)
    axel = Persona.new(30)
    lean = Persona.new(22)

    PersonaHome.mockear(:todas_las_personas) do
      [nico, axel, lean]
    end

    viejos = PersonaHome.personas_viejas

    viejos.deberia ser [nico, axel]
  end
end