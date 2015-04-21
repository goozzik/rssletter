class RSSUpdateService

  def update
    mails.each { |mail| process_mail(mail) }
  end

  private

  def mails
    Mail.find(count: 100)
  end

  def process_mail(mail)
    newsletter = find_matching_newsletter(mail)
    return unless newsletter

    unless mail_already_coverted?(newsletter, mail)
      create_rss_item(newsletter, mail)
    end
  end

  def find_matching_newsletter(mail)
    Newsletter.where(
      'domain LIKE ? OR email = ?',
      mail.from.last.split('@').last,
      mail.from.last,
    ).first
  end

  def mail_already_coverted?(newsletter, mail)
    newsletter.rss_items.where(subject: mail.subject).exists?
  end

  def create_rss_item(newsletter, mail)
    newsletter.rss_items.create
  end

end
