require 'csv'

class SalesTaxes

    TAX_EXEMPT = ["book","chocolate","pill"]
    # Tax Type
    BASIC = 0.1
    IMPORTED = 0.05
    BOTH = 0.15
    @total_price = 0
    @total_tax = 0

    def self.generate_data(row)
        quantity = row[0].to_i
        price = row[-1].to_f
        product = row[1]
        tax = tax_calc(price, product).to_f
        price_w_tax = price + tax
        @total_price += price_w_tax
        @total_tax += tax
        data = [quantity, product, price_w_tax]
        return data
    end

    def self.read_write_csv(input)
        result = []
        CSV.foreach(input, skip_blanks: true) do |row|
            next if row[0] == "Quantity"
            row = row.collect{ |e| e ? e.strip : e }
            data = generate_data(row)
            result.push(data)
        end
        CSV.open("output.csv", "w") do |csv|
            result.each do |row|
                csv << [row[0], row[1], row[2].round(2)]
            end
            csv << ["Sales Taxes: #{@total_tax.round(2)}"]
            csv << ["Total: #{@total_price.round(2)}"]
        end
    end

    def self.tax_calc(price,product)
        exempted = false
        TAX_EXEMPT.each do |word|
            if product.include? word
                exempted = true
            end
        end
        if product.include? 'imported' and !exempted
            tax = price * BOTH
        elsif product.include? 'imported' and exempted
            tax = price * IMPORTED
        elsif !exempted
            tax = price * BASIC
        else
            tax = 0
        end
        return tax
    end
end
