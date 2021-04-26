require 'sales-tax'
require 'csv'

describe SalesTaxes do
    describe ".read_write_csv" do
        context "given 'input.csv'" do
            it 'creates CSV file with proper value' do
                expected_csv = File.read("expected.csv").split("\n")
                generated_csv = CSV.read(SalesTaxes.read_write_csv("input.csv").path)

                # lines count
                expect(generated_csv.size).to eq(expected_csv.size)

                # data check
                expected = []
                expected_csv.each do |row|
                    expected.push(row.split(","))
                end
                
                expect(generated_csv).to eq(expected)
            end
        end
    end
end