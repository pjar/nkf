require 'rake'

namespace :import do
  desc "Import new companies to the db"
  task :kategorias => :environment do
    stara_ilosc = Kategoria.count
    kategorie = []
    File.open("#{ENV['path']}/kategorie.txt","r") do |f|
      kategorie = JSON.parse f.gets
    end
    puts "Tworze kategorie glowne:"
    kategorie.each do |kategoria|
      p kategoria['name']
      Kategoria.create(nazwa: kategoria["name"], glowna: true)
      puts "ok"
    end
    puts "Stworzono: #{Kategoria.count - stara_ilosc}"
  end

  task :firmas => :environment do
    counter = 0
    left = 0
    big_counter = 0
    Kategoria.all.each do |kat|
      counter += Dir.glob("#{ENV['path']}/#{kat.nazwa}/*").size
    end
    Kategoria.all.each do |kategoria|
      root_dir = "#{ENV['path']}/#{kategoria.nazwa}"
      Dir.foreach(root_dir) do |item|
        next if item == "." or item == ".."
        left +=  1
        puts
        puts "#{left} / #{counter}"
        puts
        firmy_json = []
        File.open("#{root_dir}/#{item}","r") do |f|
          firmy_json = JSON.parse f.gets
        end
        left_firmy = 0
        firmy_ilosc = firmy_json.size
        firmy_json.each do |fj|
          fj = JSON.parse fj
          fj['sub_kategoria'] = "#{kategoria.nazwa}/#{item.split('.txt').first}"
          fj['adres'] = ["unknown",'unknown'] if fj['adres'].empty?
          uniq_id = fj['uniq_id'] = fj['nazwa']+"-"+fj['adres'][0]+"-"+fj['sub_kategoria']
          if !Firma.find_by_uniq_id(uniq_id)
            fj['adres'] = fj['adres'].join(";")
            nowa_firma = Firma.create(fj)#:nazwa => fj['nazwa'][1, fj['nazwa'].length-1], :adres => fj['adres'], :tel   => fj['tel'], :fax   => fj['fax'], :link  => fj['link'], :description => fj['description'], :website => fj['website'])
            nowa_firma.update_attribute("nazwa",nowa_firma.nazwa[1, nowa_firma.nazwa.length-1])
            nowa_firma.update_attribute("kategoria_id", kategoria.id)
            left_firmy += 1
            big_counter += 1
            puts "#{firmy_ilosc - left_firmy}                  #{big_counter}"
          else
            puts "D U P L I C A T E"
          end
          #puts "#{fj['website']}"
        end
      end
    end
  end
  task :generate_big_tablica => :environment do
    require 'mechanize'
    agent = Mechanize.new
    big_tablica = []
    puts "Fetching records from database..."
    calosc = Firma.count
    licznik = 0
    ActiveRecord::Base.connection.execute("select uniq_id, link from firmas").each { |ec| big_tablica << ec; licznik += 1; puts "#{calosc - licznik}"  }
    puts "Writing records to file"
    File.open(Dir::pwd+"/all_firmas.txt", "w+") do |f|
      f.write big_tablica.to_json
    end
    #TODO - finish this
  end

  task :emails => :environment do 
    require 'mechanize'
    agent = Mechanize.new
    puts "Fetching records from file..."
    big_tablica = []
    File.open(Dir::pwd+"/all_firmas.txt", "r") do |f|
      big_tablica = JSON.parse f.gets
    end
    puts big_tablica.size
    
    divided_big_tablica = big_tablica.each_slice(100000).to_a
    big_counter = divided_big_tablica.size
    puts "Database loaded, and divided into #{big_counter.to_s} parts" 
    part = ENV['part'].presence
    part = part.to_i
    tablica = []
    if part && (part <= divided_big_tablica.size - 1 || part == 0)
      tablica = divided_big_tablica[part] 
      counter = tablica.size
    else
      raise "invalid part choice, please use number between 0 and #{big_counter - 1}"
    end
    emails = 0
    tablica.each do |item| 
      begin
        page = agent.get item[1]
      rescue Exception => e
        puts e
        File.open(Dir::pwd+"/errors.log","a+") do |f|
          f.write(item[0]+"$$")
        end
        next
      end
      email = page.search("div.js-infopagePopupArea a").first.try(:text) || " "
      description = page.search("div.announcement").first.try(:text)
      if email.presence
        File.open(Dir::pwd+"/emails_acquired.txt","a+") do |f|
          f.write(item[0]+"**"+email+"$$")
        end
        firma = Firma.find_by_uniq_id(item[0])
        firma.update_attribute("email", email)
        firma.update_attribute("description", description)
        emails += 1
      end
      File.open(Dir::pwd+"/email_checked.txt","a+") do |f|
        f.write(item[0]+"**"+email+"$$")
      end
      counter -= 1
      puts "#{counter}         #{emails}" 
    end
  end
end
