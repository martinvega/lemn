# -*- coding: utf-8 -*-
require 'prawn/measurement_extensions'

DB_ADAPTER = ActiveRecord::Base.connection.adapter_name

# Ruta a la carpeta pública
PUBLIC_PATH = File.join(Rails.root, 'public')

# Opciones por defecto para los PDFs
PDF_OPTIONS = {
  :page_size => 'A4',
  :page_layout => :portrait,
  # Margen T, R, B, L
  :margin => [20.mm, 15.mm, 20.mm, 20.mm]
}
# Tamaño de fuente normal en los PDFs
PDF_FONT_SIZE = 11
