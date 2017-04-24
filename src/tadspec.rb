module TADsPEC
  class ::Object
    def deberia(asercion)
      asercion.call(self)
    end
  end

  class ::Module
    def mockear(nombre_metodo, &implementacion)
      alias_method("#{nombre_metodo}_backup", nombre_metodo)
      define_method(nombre_metodo, &implementacion)
      TADTest.agregar_metodo_mockeado(self, nombre_metodo)
    end
  end
end

class TADTest
  def self.metodos_mockeados
    @metodos_mockeados ||= []
  end

  def self.agregar_metodo_mockeado(clase, nombre_metodo)
    @metodos_mockeados = self.metodos_mockeados << [clase, nombre_metodo]
  end

  def self.limpiar_metodos
    self.metodos_mockeados.each do |clase, nombre_metodo|
      clase.send(:alias_method, nombre_metodo, "#{nombre_metodo}_backup")
      clase.send(:remove_method, "#{nombre_metodo}_backup")
    end

    @metodos_mockeados = []
  end

  def self.evalua(&bloque)
    resultado = new.instance_eval(&bloque)
    TADTest.limpiar_metodos
    resultado
  end

  def method_missing(nombre_metodo, *args, &bloque)
    if nombre_metodo.to_s.start_with?('ser_')
      nombre_metodo_booleano = nombre_metodo.to_s.split("_").last + "?"
      proc { |valor_actual| valor_actual.send(nombre_metodo_booleano) }
    elsif nombre_metodo.to_s.start_with?('tener_')
      nombre_atributo = "@" + nombre_metodo.to_s.split("_").last
      proc do |valor_actual|
        valor_actual.instance_variable_get(nombre_atributo).deberia ser(args.first)
      end
    else
      super(nombre_metodo, *args, &bloque)
    end
  end

  def respond_to_missing?(nombre_metodo)
    nombre_metodo.start_with?('ser_') || nombre_metodo.start_with?('tener_') || super(nombre_metodo)
  end

  def ser(esperado)
    if esperado.is_a? Proc
      esperado
    else
      proc { |valor_actual| valor_actual == esperado }
    end
  end

  def mayor_a(valor)
    proc { |valor_actual| valor_actual > valor}
  end
end
