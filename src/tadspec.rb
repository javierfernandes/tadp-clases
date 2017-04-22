class RefinamientoComparable
  def initialize(bloque)
    @bloque = bloque
  end
  def comparate_con(un_valor)
    @bloque.call(un_valor)
  end
end
module TestSuite

  class ::Object
    def deberia(refinamiento)
      refinamiento.call(self)
    end
    def mockear(mensaje, &bloque)
      self.define_singleton_method(mensaje, &bloque)
    end
  end

  def ser(algo)
    proc {|checkeado|
      if algo.is_a? RefinamientoComparable
        algo.comparate_con checkeado
      else
        algo == checkeado
      end
    }
  end
  def mayor_a(algo)
    RefinamientoComparable
        .new(proc {|checkeado| checkeado >= algo})
  end
  def menor_a(algo)

  end
  def entender(mensaje)
    proc {|checkeado| checkeado.respond_to? mensaje}
  end
  def polimorfico_con(modulo)
    RefinamientoComparable
      .new(proc {|checkeado|
        modulo.instance_methods(false).all? {|mensaje|
            checkeado.respond_to? mensaje
          }
        })
  end
  def no(refinamiento)
    proc {|checkeado|
      ! refinamiento.call(checkeado)
    }
  end
end
