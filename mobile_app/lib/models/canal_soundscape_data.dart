/// 京杭大运河声景数据模型
class CanalSoundscapeData {
  final String id;
  final String title;
  final String period;
  final String location;
  final double latitude;
  final double longitude;
  final String poem;
  final String poemAuthor;
  final String emotion;
  final String audioUrl;
  final String imageUrl;
  final String description;
  final bool isHistorical;

  CanalSoundscapeData({
    required this.id,
    required this.title,
    required this.period,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.poem,
    required this.poemAuthor,
    required this.emotion,
    required this.audioUrl,
    required this.imageUrl,
    required this.description,
    required this.isHistorical,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'period': period,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'poem': poem,
      'poemAuthor': poemAuthor,
      'emotion': emotion,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'description': description,
      'isHistorical': isHistorical,
    };
  }
}

/// 京杭大运河声景数据集
class CanalSoundscapeDataset {
  static final List<CanalSoundscapeData> soundscapes = [
    // 北京段
    CanalSoundscapeData(
      id: '1',
      title: '通州码头晨钟',
      period: '明代',
      location: '北京通州',
      latitude: 39.9042,
      longitude: 116.6591,
      poem: '舳舻衔尾浮清波，千帆竞发通州河',
      poemAuthor: '杨基',
      emotion: '繁忙',
      audioUrl: 'assets/audio/soundscapes/01_tongzhou_wharf.mp3',
      imageUrl: 'assets/images/soundscapes/tongzhou_wharf.jpg',
      description: '明代通州码头是京杭大运河的重要起点，每日清晨钟声响起，商船云集',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '2',
      title: '什刹海夜市',
      period: '清代',
      location: '北京什刹海',
      latitude: 39.9392,
      longitude: 116.3831,
      poem: '银桥灯火接银河，满地笙歌醉太平',
      poemAuthor: '纪晓岚',
      emotion: '热闹',
      audioUrl: 'assets/audio/soundscapes/02_shichahai_night.mp3',
      imageUrl: 'assets/images/soundscapes/shichahai_night.jpg',
      description: '清代什刹海是京城繁华之地，夜市灯火辉煌，笙歌不断',
      isHistorical: true,
    ),

    // 天津段
    CanalSoundscapeData(
      id: '3',
      title: '天津三岔口',
      period: '明代',
      location: '天津',
      latitude: 39.1467,
      longitude: 117.2056,
      poem: '三河汇流天津卫，舟楫如云商贾萃',
      poemAuthor: '佚名',
      emotion: '激昂',
      audioUrl: 'assets/audio/soundscapes/03_tianjin_sancha.mp3',
      imageUrl: 'assets/images/soundscapes/tianjin_sancha.jpg',
      description: '明代天津三岔河口，南运河、北运河、海河交汇处，水声激荡',
      isHistorical: true,
    ),

    // 河北段
    CanalSoundscapeData(
      id: '4',
      title: '沧州铁狮吼',
      period: '宋代',
      location: '河北沧州',
      latitude: 38.3037,
      longitude: 116.8575,
      poem: '铁狮镇河千年立，运河波涛日夜鸣',
      poemAuthor: '佚名',
      emotion: '威严',
      audioUrl: 'assets/audio/soundscapes/04_cangzhou_lion.mp3',
      imageUrl: 'assets/images/soundscapes/cangzhou_lion.jpg',
      description: '宋代铁狮子镇守运河，河水日夜奔腾，狮吼震天',
      isHistorical: true,
    ),

    // 山东段
    CanalSoundscapeData(
      id: '5',
      title: '德州扒鸡香',
      period: '清代',
      location: '山东德州',
      latitude: 37.4513,
      longitude: 116.3105,
      poem: '驿站飘香鸡肉醇，南来北往客满门',
      poemAuthor: '佚名',
      emotion: '温馨',
      audioUrl: 'assets/audio/soundscapes/05_dezhou_station.mp3',
      imageUrl: 'assets/images/soundscapes/dezhou_station.jpg',
      description: '清代德州是运河重要驿站，扒鸡闻名天下，商旅云集',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '6',
      title: '东昌府夜雨',
      period: '明代',
      location: '山东聊城',
      latitude: 36.4570,
      longitude: 115.9856,
      poem: '夜雨打篷船，客愁东昌府',
      poemAuthor: '佚名',
      emotion: '凄美',
      audioUrl: 'assets/audio/soundscapes/06_liaocheng_rain.mp3',
      imageUrl: 'assets/images/soundscapes/liaocheng_rain.jpg',
      description: '明代东昌府夜雨淅沥，雨声打在船篷上，客愁满怀',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '7',
      title: '济宁竹竿巷',
      period: '清代',
      location: '山东济宁',
      latitude: 35.4154,
      longitude: 116.5872,
      poem: '竹竿巷里市声喧，买卖往来笑语连',
      poemAuthor: '佚名',
      emotion: '繁忙',
      audioUrl: 'assets/audio/soundscapes/07_jining_bamboo.mp3',
      imageUrl: 'assets/images/soundscapes/jining_bamboo.jpg',
      description: '清代济宁竹竿巷是运河繁华商业区，市井喧哗',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '8',
      title: '徐州黄河渡',
      period: '明代',
      location: '江苏徐州',
      latitude: 34.2044,
      longitude: 117.2857,
      poem: '黄河之水天上来，运河波涛相激荡',
      poemAuthor: '佚名',
      emotion: '激昂',
      audioUrl: 'assets/audio/soundscapes/08_xuzhou_ferry.mp3',
      imageUrl: 'assets/images/soundscapes/xuzhou_ferry.jpg',
      description: '明代徐州是黄河与大运河交汇处，波涛激荡，气势磅礴',
      isHistorical: true,
    ),

    // 江苏段
    CanalSoundscapeData(
      id: '9',
      title: '宿迁古镇雨',
      period: '清代',
      location: '江苏宿迁',
      latitude: 33.9631,
      longitude: 118.2752,
      poem: '烟雨宿迁古镇中，渔歌互答晚来风',
      poemAuthor: '佚名',
      emotion: '宁静',
      audioUrl: 'assets/audio/soundscapes/09_suqian_town.mp3',
      imageUrl: 'assets/images/soundscapes/suqian_town.jpg',
      description: '清代宿迁古镇烟雨蒙蒙，渔歌互答，宁静祥和',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '10',
      title: '淮安漕运署',
      period: '明代',
      location: '江苏淮安',
      latitude: 33.5975,
      longitude: 119.0205,
      poem: '漕运总督府中坐，千帆万船听调度',
      poemAuthor: '佚名',
      emotion: '庄严',
      audioUrl: 'assets/audio/soundscapes/10_huaian_caoyun.mp3',
      imageUrl: 'assets/images/soundscapes/huaian_caoyun.jpg',
      description: '明代淮安是漕运总督署所在地，千帆调度，鼓号齐鸣',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '11',
      title: '扬州二十四桥',
      period: '唐代',
      location: '江苏扬州',
      latitude: 32.3912,
      longitude: 119.4129,
      poem: '二十四桥明月夜，玉人何处教吹箫',
      poemAuthor: '杜牧',
      emotion: '悠扬',
      audioUrl: 'assets/audio/soundscapes/11_yangzhou_bridge.mp3',
      imageUrl: 'assets/images/soundscapes/yangzhou_bridge.jpg',
      description: '唐代扬州二十四桥，明月夜下箫声悠扬，意境绝美',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '12',
      title: '扬州瘦西湖晨',
      period: '清代',
      location: '江苏扬州',
      latitude: 32.4086,
      longitude: 119.4273,
      poem: '瘦西湖畔晨光熹，画舫轻摇碧波里',
      poemAuthor: '佚名',
      emotion: '宁静',
      audioUrl: 'assets/audio/soundscapes/12_yangzhou_shouxi.mp3',
      imageUrl: 'assets/images/soundscapes/yangzhou_shouxi.jpg',
      description: '清代扬州瘦西湖晨曦，画舫轻摇，鸟鸣啾啾',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '13',
      title: '镇江金山寺钟',
      period: '宋代',
      location: '江苏镇江',
      latitude: 32.2044,
      longitude: 119.4514,
      poem: '金山寺里晨钟响，长江运河交汇处',
      poemAuthor: '佚名',
      emotion: '庄严',
      audioUrl: 'assets/audio/soundscapes/13_zhenjiang_jinshan.mp3',
      imageUrl: 'assets/images/soundscapes/zhenjiang_jinshan.jpg',
      description: '宋代镇江金山寺晨钟暮鼓，长江与运河在此交汇',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '14',
      title: '常州天宁寺',
      period: '唐代',
      location: '江苏常州',
      latitude: 31.7728,
      longitude: 119.9734,
      poem: '天宁宝塔耸云霄，运河船只听经声',
      poemAuthor: '佚名',
      emotion: '祥和',
      audioUrl: 'assets/audio/soundscapes/14_changzhou_tianning.mp3',
      imageUrl: 'assets/images/soundscapes/changzhou_tianning.jpg',
      description: '唐代常州天宁寺钟声悠远，运河船只静听诵经',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '15',
      title: '无锡鼋头渚',
      period: '明代',
      location: '江苏无锡',
      latitude: 31.5525,
      longitude: 120.2138,
      poem: '太湖美景鼋头渚，运河通向太湖滨',
      poemAuthor: '佚名',
      emotion: '宁静',
      audioUrl: 'assets/audio/soundscapes/15_wuxi_yuantou.mp3',
      imageUrl: 'assets/images/soundscapes/wuxi_yuantou.jpg',
      description: '明代无锡鼋头渚，太湖波涛与运河水声交织',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '16',
      title: '苏州寒山寺钟',
      period: '唐代',
      location: '江苏苏州',
      latitude: 31.3110,
      longitude: 120.5954,
      poem: '姑苏城外寒山寺，夜半钟声到客船',
      poemAuthor: '张继',
      emotion: '悠扬',
      audioUrl: 'assets/audio/soundscapes/16_suzhou_hanshan.mp3',
      imageUrl: 'assets/images/soundscapes/suzhou_hanshan.jpg',
      description: '唐代苏州寒山寺，夜半钟声传至运河客船，千古名句',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '17',
      title: '苏州平江路',
      period: '宋代',
      location: '江苏苏州',
      latitude: 31.3165,
      longitude: 120.6256,
      poem: '平江路上评弹起，小桥流水人家住',
      poemAuthor: '佚名',
      emotion: '悠扬',
      audioUrl: 'assets/audio/soundscapes/17_suzhou_pingjiang.mp3',
      imageUrl: 'assets/images/soundscapes/suzhou_pingjiang.jpg',
      description: '宋代苏州平江路，评弹声声，小桥流水，江南韵味',
      isHistorical: true,
    ),

    // 浙江段
    CanalSoundscapeData(
      id: '18',
      title: '嘉兴南湖烟雨',
      period: '明代',
      location: '浙江嘉兴',
      latitude: 30.7465,
      longitude: 120.7551,
      poem: '南湖烟雨蒙蒙里，渔歌唱晚运河边',
      poemAuthor: '佚名',
      emotion: '宁静',
      audioUrl: 'assets/audio/soundscapes/18_jiaxing_nanhu.mp3',
      imageUrl: 'assets/images/soundscapes/jiaxing_nanhu.jpg',
      description: '明代嘉兴南湖烟雨蒙蒙，渔歌悠扬，诗情画意',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '19',
      title: '湖州丝绸市',
      period: '宋代',
      location: '浙江湖州',
      latitude: 30.8703,
      longitude: 120.0933,
      poem: '湖丝天下誉，市声通四方',
      poemAuthor: '佚名',
      emotion: '繁忙',
      audioUrl: 'assets/audio/soundscapes/19_huzhou_silk.mp3',
      imageUrl: 'assets/images/soundscapes/huzhou_silk.jpg',
      description: '宋代湖州是丝绸之乡，市场商贾云集，讨价还价声不绝',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '20',
      title: '杭州拱宸桥',
      period: '明代',
      location: '浙江杭州',
      latitude: 30.3255,
      longitude: 120.1360,
      poem: '拱宸桥下水流长，千年古桥见沧桑',
      poemAuthor: '佚名',
      emotion: '悠远',
      audioUrl: 'assets/audio/soundscapes/20_hangzhou_gongchen.mp3',
      imageUrl: 'assets/images/soundscapes/hangzhou_gongchen.jpg',
      description: '明代杭州拱宸桥是运河终点标志，古桥流水，千年沧桑',
      isHistorical: true,
    ),
    CanalSoundscapeData(
      id: '21',
      title: '杭州西湖晨曦',
      period: '宋代',
      location: '浙江杭州',
      latitude: 30.2426,
      longitude: 120.1395,
      poem: '欲把西湖比西子，淡妆浓抹总相宜',
      poemAuthor: '苏轼',
      emotion: '宁静',
      audioUrl: 'assets/audio/soundscapes/21_hangzhou_xihu.mp3',
      imageUrl: 'assets/images/soundscapes/hangzhou_xihu.jpg',
      description: '宋代杭州西湖晨曦，鸟鸣湖光，诗意盎然',
      isHistorical: true,
    ),

    // 现代声景
    CanalSoundscapeData(
      id: '22',
      title: '现代通州运河公园',
      period: '现代',
      location: '北京通州',
      latitude: 39.9042,
      longitude: 116.6591,
      poem: '千年运河今犹在，生态廊道展新颜',
      poemAuthor: '当代',
      emotion: '活力',
      audioUrl: 'assets/audio/soundscapes/22_modern_tongzhou.mp3',
      imageUrl: 'assets/images/soundscapes/modern_tongzhou.jpg',
      description: '现代通州运河文化公园，市民休闲，孩童嬉戏，生机勃勃',
      isHistorical: false,
    ),
    CanalSoundscapeData(
      id: '23',
      title: '现代扬州瘦西湖',
      period: '现代',
      location: '江苏扬州',
      latitude: 32.4086,
      longitude: 119.4273,
      poem: '古韵今风相辉映，游人如织赏湖光',
      poemAuthor: '当代',
      emotion: '欢快',
      audioUrl: 'assets/audio/soundscapes/23_modern_yangzhou.mp3',
      imageUrl: 'assets/images/soundscapes/modern_yangzhou.jpg',
      description: '现代扬州瘦西湖景区，游客如织，欢声笑语，古今交融',
      isHistorical: false,
    ),
    CanalSoundscapeData(
      id: '24',
      title: '现代杭州运河夜景',
      period: '现代',
      location: '浙江杭州',
      latitude: 30.3255,
      longitude: 120.1360,
      poem: '灯光璀璨映运河，音乐喷泉舞翩跹',
      poemAuthor: '当代',
      emotion: '繁华',
      audioUrl: 'assets/audio/soundscapes/24_modern_hangzhou.mp3',
      imageUrl: 'assets/images/soundscapes/modern_hangzhou.jpg',
      description: '现代杭州运河夜景，灯光璀璨，音乐喷泉，现代繁华',
      isHistorical: false,
    ),
  ];

  /// 根据ID查找声景
  static CanalSoundscapeData? findById(String id) {
    try {
      return soundscapes.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取历史声景
  static List<CanalSoundscapeData> getHistoricalSoundscapes() {
    return soundscapes.where((s) => s.isHistorical).toList();
  }

  /// 获取现代声景
  static List<CanalSoundscapeData> getModernSoundscapes() {
    return soundscapes.where((s) => !s.isHistorical).toList();
  }

  /// 根据地点搜索
  static List<CanalSoundscapeData> searchByLocation(String location) {
    return soundscapes.where((s) => s.location.contains(location)).toList();
  }

  /// 根据情感搜索
  static List<CanalSoundscapeData> searchByEmotion(String emotion) {
    return soundscapes.where((s) => s.emotion == emotion).toList();
  }
}
