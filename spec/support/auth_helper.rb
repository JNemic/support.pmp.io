#
# shortcuts for authorizing with the pmp
#
module AuthHelper

  def pmp_host
    ENV['PMP_HOST'] || raise('You forgot to set PMP_HOST')
  end

  def pmp_username
    ENV['PMP_USERNAME'] || raise('You forgot to set PMP_USERNAME')
  end

  def pmp_password
    ENV['PMP_PASSWORD'] || raise('You forgot to set PMP_PASSWORD')
  end

  # bypass javascript dropdown
  def set_host_picker(host)
    Rails.application.secrets.pmp_hosts.each do |name, cfg|
      host = name if cfg['host'].include?(host)
    end
    page.find('.host-picker').all('input', visible: false).first.set(host)
  end

  # manually log in user
  def do_login!
    visit login_path
    set_host_picker pmp_host
    fill_in 'Username', with: pmp_username
    fill_in 'Password', with: pmp_password
    click_button 'Sign in'
    expect(page).to have_content('You are now logged in')
    expect(page.body).to match(%r{#{pmp_username}@#{pmp_host.gsub(/^http(s):\/\//, '')}}i)
  end

end
