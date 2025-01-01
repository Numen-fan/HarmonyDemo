import { media } from "@kit.MediaKit";
import { audio } from "@kit.AudioKit";
import { ImageOption } from "../model/ImageOption";
import { AudioOption } from "../model/AudioOption";
import { MeritRecord } from "../model/MeritRecord";

export class MuyuBloc {
  private player?: media.SoundPool
  private ready = false
  @Track counter: number = 0;
  @Track activeImageIndex: number = 0
  @Track imageOptions: ImageOption[] = [
    new ImageOption('基础版', $r('app.media.muyu'), 1, 3),
    new ImageOption('尊享版', $r('app.media.muyu2'), 3, 6),
  ]

  // 音频
  private soundIds:number[] = []
  @Track activeAudioIndex: number = 0
  @Track audioOptions:AudioOption[] = [
    new AudioOption('空灵弥音', 'muyu_1.mp3'),
    new AudioOption('落子禅定', 'muyu_2.mp3'),
    new AudioOption('滴水明镜', 'muyu_3.mp3'),
  ]

  // 记录
  @Track records: MeritRecord[] = [];
  @Track lastRecord?: MeritRecord | null;

  constructor() {
    this.initAndLoad()
  }

  async initAndLoad() {
    await this.initSoundPool()
    await this.loadSounds()
    this.ready = true
  }

  async initSoundPool() {
    this.player = await media.createSoundPool(1, {
      usage: audio.StreamUsage.STREAM_USAGE_GAME,
      rendererFlags: 1
    })
  }

  async loadSounds() {
    this.soundIds = [];
    for (let i = 0; i < this.audioOptions.length; i++) {
      let audio: AudioOption = this.audioOptions[i];
      let id = await this.loadSoundId(audio.src);
      this.soundIds.push(id);
    }
  }

  async loadSoundId(rawFile: string): Promise<number> {
    let res = await getContext().resourceManager.getRawFd(rawFile)
    return new Promise<number>((resolve, reject) => {
      this.player!.load(res.fd, res.offset, res.length, (error, id: number) => {
        if (!error) {
          resolve(id)
        } else {
          reject(error)
        }
      })
    })
  }

  tick(): void {
    if (!this.ready) {
      return
    }
    this.player?.play(this.soundIds![this.activeAudioIndex])
    // 功德记录
    let image: ImageOption = this.imageOptions[this.activeImageIndex];
    let audio: AudioOption = this.audioOptions[this.activeAudioIndex];
    let value = Math.floor(Math.random() * (image.max - image.min + 1)) + image.min;
    this.lastRecord = new MeritRecord({
      timestamp: Date.now(),
      value: value,
      image: image.src,
      audio: audio.name,
    });
    this.records.push(this.lastRecord)
    this.counter += value
  }

  imageSrc(): ResourceStr {
    return this.imageOptions[this.activeImageIndex].src
  }

  changeImage(index: number) {
    this.activeImageIndex = index
  }

  changeVoice(index:number) {
    this.activeAudioIndex = index
  }

  previewAudio(index: number) {
    if (!this.ready) {
      return
    }
    this.player?.play(this.soundIds![index])
  }


  async release() {
    await this.player?.release()
    this.ready = false
  }
}