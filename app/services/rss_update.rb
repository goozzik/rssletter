class RSSUpdate
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
      create_newsletter_item(newsletter, mail)
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
    newsletter.items.where(title: mail.subject).exists?
  end

  def create_newsletter_item(newsletter, mail)
    newsletter.items.create(
      title: mail.subject, content: get_content_from_mail(mail)
    )
  end

  def get_content_from_mail(mail)
    content = ''

    if mail.body.parts.blank?
      content = mail.body.to_s
    else
      mail.body.parts.each do |part|
        if mail_part_is_html?(part.content_type)
          content = part.body.to_s
          break
        end
      end
    end

    content.force_encoding('utf-8')
  end

  def mail_part_is_html?(part_content_type)
    !!part_content_type.match(/^text\/html/)
  end
end
