package com.example.basic_video_chat_flutter

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import com.example.knovi_call.R
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class VideoFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        private lateinit var view: VideoPlatformView

        fun getViewInstance(context: Context): VideoPlatformView {
            if(!this::view.isInitialized) {
                view = VideoPlatformView(context)
            }

            return view
        }
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return getViewInstance(context)
    }
}

class VideoPlatformView(context: Context) : PlatformView {
    private val videoContainer: VideoContainer = VideoContainer(context)

    val subscriberContainer get() = videoContainer.subscriberContainer
    val publisherContainer get() = videoContainer.publisherContainer

    override fun getView(): View {
        return videoContainer
    }

    override fun dispose() {}
}

class VideoContainer @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyle: Int = 0,
    defStyleRes: Int = 0
) : LinearLayout(context, attrs, defStyle, defStyleRes) {

    var subscriberContainer: FrameLayout
        private set

    var publisherContainer: FrameLayout
        private set

    init {
        val view = LayoutInflater.from(context).inflate(R.layout.video_call_view, this, true)
        subscriberContainer = view.findViewById(R.id.subscriber_container)
        publisherContainer = view.findViewById(R.id.publisher_container)
    }
}