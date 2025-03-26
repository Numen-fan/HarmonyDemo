import preferences from "@ohos.data.preferences";


export class PreferencesUtil {
  private static mPreferencesUtil?: PreferencesUtil = undefined

  private constructor() {
  }

  public static getPreferencesUtil(): PreferencesUtil {
    if (PreferencesUtil.mPreferencesUtil == undefined) {
      PreferencesUtil.mPreferencesUtil = new PreferencesUtil()
    }
    return PreferencesUtil.mPreferencesUtil
  }

  private dataPreferences: preferences.Preferences | null = null

  init(context: Context) {
    let options: preferences.Options = { name: 'search' }
    this.dataPreferences = preferences.getPreferencesSync(context, options);
  }

  public put(key: string, value: string) {
    this.dataPreferences?.putSync(key, value)
    this.dataPreferences?.flush()
  }

  public get(key: string): string {
    return this.dataPreferences?.getSync(key, "") as string
  }

  public delete(key: string) {
    this.dataPreferences?.deleteSync(key)
  }
}