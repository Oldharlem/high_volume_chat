import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = {
    groupId: Number,
    userId: Number,
    loading: Boolean,
    offset: { type: Number, default: 20 }
  }

  static targets = ["messages", "form", "input"]

  connect() {
    console.log("GroupSubscription controller connected")
    console.log("Targets found:", {
      messages: this.hasMessagesTarget,
      form: this.hasFormTarget,
      input: this.hasInputTarget
    })
    console.log("Values:", {
      groupId: this.groupIdValue,
      userId: this.userIdValue
    })

    this.channel = createConsumer().subscriptions.create({
      channel: "GroupChannel",
      group_id: this.groupIdValue
    }, {
      connected: () => {
        console.log("Connected to GroupChannel")
      },
      disconnected: () => {
        console.log("Disconnected from GroupChannel")
      },
      received: this.handleMessage.bind(this),
      rejected: () => {
        console.log("Subscription was rejected")
      }
    })
    
    this.scrollToBottom()
    this.messagesTarget.addEventListener('scroll', this.handleScroll.bind(this))
  }

  disconnect() {
    this.messagesTarget.removeEventListener('scroll', this.handleScroll.bind(this))
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  async submitMessage(event) {
    event.preventDefault()
    
    const form = event.target
    const input = this.inputTarget
    const originalValue = input.value

    if (!originalValue.trim()) return

    try {
      const response = await fetch(form.action, {
        method: form.method,
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: new FormData(form)
      })

      const data = await response.json()
      
      if (data.success) {
        input.value = ""
        this.renderMessage(data.message)
        this.scrollToBottom()
      } else {
        input.value = originalValue
        alert(data.errors.join(", "))
      }
    } catch (error) {
      console.error("Error sending message:", error)
      input.value = originalValue
      alert("Failed to send message. Please try again.")
    }
  }

  handleMessage(data) {
    if (data.success && data.message.user.id !== this.userIdValue) {
      this.renderMessage(data.message)
      this.scrollToBottom()
    }
  }

  async handleScroll() {
    if (this.loadingValue) return

    const { scrollTop, scrollHeight, clientHeight } = this.messagesTarget
    // Load more when scrolled near the top (within 100px)
    if (scrollTop < 100) {
      await this.loadMoreMessages()
    }
  }

  async loadMoreMessages() {
    this.loadingValue = true
    
    try {
      const response = await fetch(`/groups/${this.groupIdValue}/messages?offset=${this.offsetValue}`, {
        headers: {
          "Accept": "application/json"
        }
      })
      
      const data = await response.json()
      
      if (data.messages.length > 0) {
        // Store current scroll position
        const oldScrollHeight = this.messagesTarget.scrollHeight
        
        // Prepend messages
        data.messages.forEach(message => {
          this.renderMessage(message, 'prepend')
        })
        
        // Maintain scroll position
        const newScrollHeight = this.messagesTarget.scrollHeight
        this.messagesTarget.scrollTop = newScrollHeight - oldScrollHeight
        
        this.offsetValue += data.messages.length
      }
    } catch (error) {
      console.error("Error loading messages:", error)
    } finally {
      this.loadingValue = false
    }
  }

  renderMessage(message, position = 'append') {
    const isCurrentUser = message.user.id === this.userIdValue
    const html = `
      <div class="message mb-4">
        <div class="flex items-start ${isCurrentUser ? 'justify-end' : 'justify-start'}">
          <div class="flex-1 max-w-[80%]">
            <div class="flex items-center ${isCurrentUser ? 'justify-end' : 'justify-start'}">
              ${!isCurrentUser ? `<span class="font-medium text-gray-900">${message.user.name}</span>` : ''}
              <span class="text-sm text-gray-500 ${isCurrentUser ? 'mr-2' : 'ml-2'}">
                ${new Date(message.created_at).toLocaleTimeString()}
              </span>
            </div>
            <div class="mt-1">
              <div class="${isCurrentUser ? 
                'bg-indigo-600 text-white rounded-l-lg rounded-tr-lg' : 
                'bg-gray-100 text-gray-900 rounded-r-lg rounded-tl-lg'} 
                px-4 py-2 break-words">
                ${message.body}
              </div>
            </div>
          </div>
        </div>
      </div>
    `
    if (position === 'prepend') {
      this.messagesTarget.insertAdjacentHTML("afterbegin", html)
    } else {
      this.messagesTarget.insertAdjacentHTML("beforeend", html)
    }
  }

  handleKeydown(event) {
    console.log("handleKeydown called", event.key)
    // Submit on Enter (but not with Shift+Enter)
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      console.log("Enter pressed, submitting form")
      this.formTarget.requestSubmit()
    }
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
} 