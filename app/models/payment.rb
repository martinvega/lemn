# -*- coding: utf-8 -*-
class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :amount, :concept, :date, :lock_version, :partner_id
  attr_reader :next_payment_date

  # Default order
  default_scope order('date DESC')

  # Named scopes
  scope :by_partner, lambda { |id|
    where('partner_id = ?', id)
  }
  scope :between_dates, lambda { |from, to|
    where('date between :from AND :to',
      :from => from,
      :to => to
    )
  }
  # Validations
  validates :date, :amount, :concept, :partner_id, :user_id, :presence => true
  validates :concept, :length => { :maximum => 255 }, :allow_nil => true, :allow_blank => true
  validates :amount, :numericality => { :maximum => 9999 }, :allow_nil => true, :allow_blank => true
  validates_date :date, :on_or_before => 7.days.from_now.to_date , :allow_nil => true, :allow_blank => true
  validates :date, :uniqueness => { :scope => :partner_id }

  # Relations
  belongs_to :user
  belongs_to :partner

  def self.filtered_list(query)
    query.present? ?
      where('concept LIKE :q', :q => "%#{query.downcase}%") : scoped
  end

  def next_payment_date
    self.date.next_month
  end

  def to_s
    self.concept
  end

  def self.expired_or_next_to(expired = false)
    if expired
      payments = Payment.between_dates(3.months.ago.to_date, 1.month.ago.to_date)
      not_expired = Payment.select('partner_id').between_dates(1.month.ago.to_date + 1, Date.today).map(
        &:partner_id
      )
    else
      payments = Payment.between_dates(1.month.ago.to_date + 1, 1.month.ago.to_date + 7)
      not_expired = Payment.select('partner_id').between_dates(7.days.ago.to_date, 7.days.from_now.to_date).map(
        &:partner_id
      )
    end
    filtered_payments = []
    ids = []

    payments.each do |p|
      id = p.partner_id
      if ids.exclude?(id) && not_expired.exclude?(id)
        ids << id
        filtered_payments << p
      end
    end

    if expired
      filtered_payments
    else
      filtered_payments.reverse!
    end
  end

  def get_style
    if self.date <= Date.today.prev_month
      style = "class='expired'"
    elsif self.date > Date.today.prev_month && self.date <= 24.days.ago.to_date
      style = "class='next_to_expire'"
    else
      style = nil
    end

    style
  end

  def self.to_pdf(payments, user)
    pdf = Prawn::Document.new(PDF_OPTIONS)
    pdf.font_size = PDF_FONT_SIZE

    # Imagen
    image = "#{Rails.root.to_s}/public/images/pdf_logo.jpg"
    pdf.image image, :scale => 0.1

    # Encabezado
    pdf.font_size((PDF_FONT_SIZE * 0.7).round) do
      pdf.move_down pdf.font_size
      pdf.text "Generado por #{user}", :align => :right
      pdf.move_down pdf.font_size
    end

    # Título
    pdf.font_size((PDF_FONT_SIZE * 1.1).round) do
      pdf.move_down pdf.font_size
      date = I18n.l(Date.today, :format => :long)
      pdf.text "#{I18n.t('view.payments.list_by_date')} #{date}", :style => :bold, :align => :center
      pdf.move_down pdf.font_size
    end

    # Variables tabla
    data = []

    data[0] = [I18n.t('activerecord.attributes.payment.date'), I18n.t('activerecord.attributes.payment.concept'),
      I18n.t('activerecord.attributes.payment.amount'), I18n.t('activerecord.attributes.payment.partner_id'),
      I18n.t('activerecord.attributes.payment.next_payment_date') ]

    payments.each_with_index do |payment, i|
      data[i+1] = [I18n.l(payment.date, :format => :long), payment.concept, payment.amount, payment.partner.to_s,
        I18n.l(payment.next_payment_date, :format => :long)]
    end

    pdf.font_size((PDF_FONT_SIZE * 0.6).round) do
      pdf.move_down pdf.font_size
      pdf.table data, :row_colors => ["FFFFFF","DDDDDD"],
        :width => pdf.margin_box.width
    end
    # Numeración en pie de página
    pdf.page_count.times do |i|
      pdf.go_to_page(i+1)
      pdf.draw_text "#{i+1} / #{pdf.page_count}", :at=>[1,1], :size => (PDF_FONT_SIZE * 0.75).round
    end

    FileUtils.mkdir_p File.dirname(Payment.pdf_full_path)
    pdf.render_file Payment.pdf_full_path

  end

  def self.pdf_name
    "#{I18n.t 'view.payments.pdf_name'}-#{Date.today}.pdf"
  end

  def self.pdf_relative_path
    File.join(*(['pdfs'] + [Payment.pdf_name]))
  end

  def self.pdf_full_path
    File.join(PUBLIC_PATH, Payment.pdf_relative_path)
  end
end
