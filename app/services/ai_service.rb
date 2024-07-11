class AiService
  require 'json'

  def initialize(prompt)
    @prompt = prompt
  end

  def call
    complex_prompt = 'I spent $27.50 at Jade Chicken today. This includes a $7.50 chicken tenders and $20 half chicken. Generate a json that describes this expense including the establishment, date, amount, category and items bought.'
    complex_schema = {
      type: 'object',
      properties: {
        expense: {
          type: 'object',
          properties: {
            establishment: {
              type: 'string'
            },
            date: {
              type: 'string'
            },
            amount: {
              type: 'number'
            },
            category: {
              type: 'string',
              enum: ['Food', 'Transportation', 'Entertainment', 'Groceries', 'Apparel']
            },
            items_bought: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  name: {
                    type: 'string'
                  },
                  amount: {
                    type: 'number'
                  }
                }
              }
            }
          }
        }
      }
    }

    simple_prompt = 'I spent $10.50 at Cold Storage on vegetables and fruits today. Generate a json that describes this expense.'
    simple_schema = {
      type: 'object',
      properties: {
        expense: {
          type: 'object',
          properties: {
            establishment: {
              type: 'string'
            },
            amount: {
              type: 'number'
            },
            category: {
              type: 'string',
              enum: ['Food', 'Transportation', 'Entertainment', 'Groceries', 'Apparel']
            },
          },
          required: ['establishment', 'amount', 'category']
        }
      }
    }

    result = client.generate_content({
      contents: {
        role: 'user',
        parts: {
          text: @prompt + " Generate a json that describes this expense."
        }
      },
      generation_config: {
        response_mime_type: 'application/json',
        response_schema: simple_schema
      }
    })
    puts result
    text = result['candidates'][0]['content']['parts'][0]['text']
    parsed_text = JSON.parse(text)
    puts parsed_text
    return parsed_text
  end

  private

  def client
    # service account credentials
    @_client ||= Gemini.new(
      credentials: {
        service: 'vertex-ai-api',
        file_contents: File.read('google-credentials.json'),
        region: 'asia-southeast1'
      },
      options: { model: 'gemini-1.5-pro', server_sent_events: true }
    )
  end

end


# Comical responses to the complex prompt and using complex schema
# {"expense"=>{"establishment"=>"Jade Chicken", "items_bought"=>[{"name"=>"chicken tenders"}, {"name"=>"half chicken"}]}}
# {"expense"=>{"establishment"=>"Jade Chicken", "items_bought"=>[{"name"=>"chicken tenders combo with fries and drink"}, {"name"=>"Half Chicken with two sides"}]}}
# {"expense"=>{"establishment"=>"Jade Chicken", "items_bought"=>[{"name"=>"chicken tenders combo with fries and drink"}, {"name"=>"Half Chicken with two sides"}]}}

# {"expense"=>{"establishment"=>"Jade Chicken", "items_bought"=>[{"name"=>"chicken tenders combo meal (3 pc.) with fries & drink (M size) & honey mustard sauce (2 pc.) only $7.50 each until Friday only at participating locations only while supplies last tax excluded from price no substitutions please and thank you very much come again soon drive-thru or take-out only please do not eat in car we are not responsible for any injuries sustained while consuming our food this is not a toy do not taunt happy fun time hour deals are for a limited time only prices may vary by location see store for details and restrictions no cash value sorry no rainchecks prices and participation may vary sorry charlie no returns please see manager for details we reserve the right to refuse service to anyone this offer is not valid in conjunction with any other offer or discount not valid for employees of Jade Chicken or their immediate family members void where prohibited by law cash value 1/20 of one cent please drink responsibly must be 18 years or older to purchase alcohol subject to availability no purchase necessary this is not a solicitation to purchase alcohol please do not litter keep America beautiful thank you for your patronage and have a nice day y'all come back now ya hear we appreciate your business have a great day and God bless the United States of America home of the free and the brave land that I love stand beside her and guide her through the night with the light from above from the mountains to the prairies to the oceans white with foam God bless America my home sweet home. God bless us everyone! And God bless Jade Chicken! Amen!  (extra crispy please and thank you) lol jk  ;))  <3 xoxo -management  ps - please be kind to our employees they are working hard to serve you  :)  we appreciate your understanding!  Thank you for choosing Jade Chicken!  We are committed to providing our customers with the best possible dining experience.  Please let us know if you have any questions or concerns.  We value your feedback!  Have a great day!  :)"}, {"name"=>"Half Chicken"}]}}
