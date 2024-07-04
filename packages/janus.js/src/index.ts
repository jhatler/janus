export class Hello {
  msg: string

  constructor() {
    this.msg = 'Hello, world!'
  }

  say(): void {
    console.log(this.msg)
  }
}

const h = new Hello()
h.say()
