#!ruby
#encoding: utf-8
#
#
#Programa de Registro de Alumnos

require 'csv'

class VAlumno
  def muestraVentanaRegistro
    alumno = NAlumno.new

    print 'Nombre del alumno: '
    alumno.nombre = gets.chomp
    print 'Dirección: '
    alumno.direccion = gets.chomp
    print 'Boleta: '
    alumno.boleta = gets.chomp
    print 'Correo: '
    alumno.correo = gets.chomp

    while true do

      puts "\nLa información es la siguiente:"
      puts "\n\t1. Nombre: #{alumno.nombre}"
      puts "\t2. Direccóon: #{alumno.direccion}"
      puts "\t3. Boleta: #{alumno.boleta}"
      puts "\t4. Correo: #{alumno.correo}"
      print "\n¿Es correcta? (Presione \"s\" para registrar al alumno o el número del campo a corregir): "
      op = gets.chomp

      case op
      when '1'
        print 'Nombre del alumno: '
        alumno.nombre = gets.chomp
      when '2'
        print 'Dirección: '
        alumno.direccion = gets.chomp
      when '3'
        print 'Boleta: '
        alumno.boleta = gets.chomp
      when '4'
        print 'Correo: '
        alumno.correo = gets.chomp
      when 's', 'S'
        if alumno.validaDatos
          alumno.registra
          break
        else
          puts 'Error, los datos no son válidos...'
        end
      else
        puts 'Opcion no válida...'
      end
    end
  end
end

class NAlumno
  attr_reader :nombre, :direccion, :boleta, :correo
  attr_writer :nombre, :direccion, :boleta, :correo

  def validaDatos
    if @nombre.empty? or @direccion.empty? or @boleta.empty? or @correo.empty?
      false
    else
      true
    end
  end

  def registra
    bdAl = BDAlumno.new

    bdAl.abreConexion
    bdAl.generaConsulta self
    bdAl.ejecutaConsulta
  end
end

class BDAlumno
  def abreConexion
    @csv = CSV.open('RegistroAlumnos.csv', 'w')
  end

  def generaConsulta(alumno)
    @lista = [alumno.nombre.to_s, alumno.direccion.to_s, alumno.boleta.to_i, alumno.correo.to_s]
  end

  def ejecutaConsulta
    if @csv << @lista
      @csv.close
      return true
    else
      return false
    end
  end
  def cierraConexion
    #codigo para cerrar la conexion a la BD
  end
end

################################### Aki comienza el Programa #########################

variable = VAlumno.new
variable.muestraVentanaRegistro

