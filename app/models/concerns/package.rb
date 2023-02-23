module Package
  extend ActiveSupport::Concern
  extend ActionView::Helpers::NumberHelper
  included do
    enum package_unit: {
      mg: 1,
      g: 2,
      kg: 3,
      t: 6,
      ml: 4,
      l: 5
    }
  end
  UNIT_HASH = {
    1 => "mg",
    2 => "g" ,
    3 => "kg",
    6 => "t",
    4 => "ml",
    5 => "l"
  }

  CN_HASH = {
    1 => "毫克",
    2 => "克" ,
    3 => "千克",
    6 => "吨",
    4 => "毫升",
    5 => "升"
  }

  def self.unit_name(unit)
    s = UNIT_HASH[unit]
    s = s || unit.to_s
    s = s.strip
    ['t','ml','l'].include?(s) ? s.upcase : s
  end

  def self.package_str(package, package_unit, package_count=1)
    return nil if package.to_f <= 0 || package_unit.blank?
    if package_count.to_f != 1
      "#{package_count}*#{number_with_precision(package,strip_insignificant_zeros: true)}#{unit_name(package_unit)}"
    else
      "#{number_with_precision(package,strip_insignificant_zeros: true)}#{unit_name(package_unit)}"
    end
  end

  def package_str
    Package.package_str(package, package_unit)
  end

  # 换算单位，0.1g => 100mg, 0.000001t => 1g, 2000kg => 2t
  def self.convert_package(package, unit)
    3.times do
      if package.to_f >= 1000.0 && unit != 6 && unit != 5
          package = package.to_f/1000.0
          unit += unit == 3 ? 3 : 1
      else
        break
      end
    end
    3.times do
      if package.to_f < 1.0 && unit != 1 && unit != 4
        package = package.to_f * 1000.0
        unit -= unit == 6 ? 3 : 1
      else
        break
      end
    end
    [package, unit]
  end

end
