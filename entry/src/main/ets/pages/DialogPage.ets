
@Preview
@Entry
@Component
struct DialogPage {
  build() {
    Column({space:10}) {
      TextInput({placeholder:'请输入账号'})
        .onBlur(()=> {
          // 开始loading
          setTimeout(()=> {
            AlertDialog.show({title:'提醒', message:"账号不合规", autoCancel:false, })
          }, 500)
        })

      TextInput({placeholder:'请输入密码'})
    }.width('100%')
    .height('100%')
  }
}