#!ruby
#encoding: utf-8

require 'sqlite3'

module ALUMNO

  class VAlumno
    def initialize(dbName = 'registro')
      @dbName = dbName
    end

    def muestraVentanaRegistro
      alumno = NAlumno.new @dbName

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

    def initialize(dbName)
      @dbName = dbName
    end

    def validaDatos
      if @nombre.empty? or @direccion.empty? or @boleta.empty? or @correo.empty? or @boleta.to_i == 0
        false
      else
        true
      end
    end

    def registra
      bdAl = BDAlumno.new @dbName

      bdAl.abreConexion
      bdAl.generaConsulta
      bdAl.ejecutaConsulta self
    end
  end

  class BDAlumno
    attr_reader :dbName
    attr_writer :dbName

    def initialize(dbName)
      unless dbName.end_with? '.db'
        dbName += '.db'
      end

      @dbName = dbName
    end

    def abreConexion
      @db = SQLite3::Database.new @dbName
      unless @db.table_info('alumnos').count > 0
        @db.execute "create table alumnos(nombre nvarchar(100), direccion nvarchar(200), boleta int, correo nvarchar(20))"
      end
    end

    def generaConsulta
      @query = @db.prepare("insert into alumnos values(?, ?, ?, ?)")
    end

    def ejecutaConsulta(alumno)
      @query.bind_params(alumno.nombre, alumno.direccion, alumno.boleta.to_i, alumno.correo)
      @query.execute
    end
    def cierraConexion
      #No se necesita cerrar la conexion porque es un archivo de SQLite
    end
  end
end
